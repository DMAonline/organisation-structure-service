require 'spec_helper'
require_relative '../../api/organisation_units_controller'

describe Api::OrganisationUnitsController do

  include Rack::Test::Methods
  include Warden::Test::Helpers

  after { Warden.test_reset! }

  before do
    @tenant_id = SecureRandom.uuid
    @institution = OrganisationUnit.create({
                                               tenant_id: @tenant_id,
                                               name: 'Lancaster University',
                                               unit_type: 'University',
                                               system_id: 'e2e90623-299c-4c58-8d46-42d53c288626',
                                               system_name: 'pure',
                                               system_modified_at: '2018-04-11T01:00:21.500000000+01:00'
                                           })
    @faculty = OrganisationUnit.create({
                                        tenant_id: @tenant_id,
                                        name: 'Faculty of Health and Medicine',
                                        unit_type: 'Faculty',
                                        parent_id: @institution.id,
                                        system_id: '8a58c4ad-2d5a-463a-841a-38839ff73a63',
                                        system_name: 'pure',
                                        system_modified_at: '2018-04-11T01:00:14.580000000+01:00'
                                    })
    @faculty2 = OrganisationUnit.create({
                                            tenant_id: @tenant_id,
                                            name: 'Management School',
                                            unit_type: 'Faculty',
                                            parent_id: @institution.id,
                                            system_id: 'a5d74309-4d57-4e8c-a90f-6e43bb66b57d',
                                            system_name: 'pure',
                                            system_modified_at: '2018-04-11T01:00:14.580000000+01:00'
                                        })
    @faculty3_other_system = OrganisationUnit.create({
                                            tenant_id: @tenant_id,
                                            name: 'Management School',
                                            unit_type: 'Faculty',
                                            parent_id: '',
                                            system_id: 'a5d74309-4d57-4e8c-a90f-6e43bb66b57d',
                                            system_name: 'notpure',
                                            system_modified_at: '2018-04-11T01:00:14.580000000+01:00'
                                        })
  end

  def app
    Api::OrganisationUnitsController
  end

  it 'returns 401 response if not authenticated' do

    get '/', "CONTENT_TYPE" => "application/json"

    body = JSON.parse(last_response.body)

    assert_equal 401, last_response.status
    assert_equal 401, body["status"]["code"]
    assert_equal "Invalid authentication token", body["status"]["message"]

  end

  it 'returns 200 response with empty array when no organisation units for tenant' do

    login_as tenant_user_no_units

    get '/', "CONTENT_TYPE" => "application/json"

    org_units = JSON.parse(last_response.body)["organisation_units"]

    assert_equal 200, last_response.status
    assert_equal 0, org_units.length

  end

  it 'returns 200 response with array when organisation units for tenant' do

    login_as tenant_user_with_units

    get '/', "CONTENT_TYPE" => "application/json"

    org_units = JSON.parse(last_response.body)["organisation_units"]

    assert_equal 200, last_response.status
    assert_equal 4, org_units.length
    assert_instance_of Array, org_units

  end

  it 'respects type filter option specified on the request and returns correct results' do

    login_as tenant_user_with_units

    get '/?type=Faculty', "CONTENT_TYPE" => "application/json"

    org_units = JSON.parse(last_response.body)["organisation_units"]

    assert_equal 200, last_response.status
    assert_equal 3, org_units.length
    assert_instance_of Array, org_units

  end

  it 'respects parent id filter option and only returns org units with that parent' do

    login_as tenant_user_with_units

    get "/?parent_id=#{@institution.id}", "CONTENT_TYPE" => "application/json"

    org_units = JSON.parse(last_response.body)["organisation_units"]

    assert_equal 200, last_response.status
    assert_equal 2, org_units.length
    assert_instance_of Array, org_units

    org_units.each do |unit|
      assert_equal @institution.id, unit["parent_id"]
    end

  end

  it 'respects system id filter option and only returns org units with that system id' do

    login_as tenant_user_with_units

    system_id = @faculty3_other_system.system_id

    get "/?system_id=#{system_id}", "CONTENT_TYPE" => "application/json"

    org_units = JSON.parse(last_response.body)["organisation_units"]

    assert_equal 200, last_response.status
    assert_equal 2, org_units.length
    assert_instance_of Array, org_units

    org_units.each do |unit|
      assert_equal system_id, unit["system_id"]
    end

  end

  it 'respects system filter option and only returns org units from that system' do

    login_as tenant_user_with_units

    get "/?system=pure", "CONTENT_TYPE" => "application/json"

    org_units = JSON.parse(last_response.body)["organisation_units"]

    assert_equal 200, last_response.status
    assert_equal 3, org_units.length
    assert_instance_of Array, org_units

    org_units.each do |unit|
      assert_equal 'pure', unit["system_name"]
    end

  end

  it 'allows filters to be combined and only returns org units when that combination is true' do

    login_as tenant_user_with_units

    system_id = @faculty3_other_system.system_id

    get "/?system_id=#{system_id}&system=pure", "CONTENT_TYPE" => "application/json"

    org_units = JSON.parse(last_response.body)["organisation_units"]

    assert_equal 200, last_response.status
    assert_equal 1, org_units.length
    assert_instance_of Array, org_units

    org_units.each do |unit|
      assert_equal system_id, unit["system_id"]
    end

  end

  it 'returns 200 status code with organisation unit when org unit id exists for tenant' do

    login_as tenant_user_with_units

    get "/#{@faculty.id}", "CONTENT_TYPE" => "application/json"

    org_unit = JSON.parse(last_response.body)["organisation_unit"]

    assert_equal 200, last_response.status

    assert_equal @faculty.id, org_unit["id"]
    assert_equal @faculty.name, org_unit["name"]
    assert_equal @faculty.unit_type, org_unit["unit_type"]

  end

  it 'returns 404 status code when organisation unit does not exist for tenant' do

    login_as tenant_user_no_units

    get "/#{@faculty.id}", "CONTENT_TYPE" => "application/json"

    body = JSON.parse(last_response.body)

    assert_equal 404, last_response.status
    assert_equal 404, body["status"]["code"]
    assert_equal "No Organisation Unit found for specified id", body["status"]["message"]

  end

  private

  def tenant_user_no_units
    tenant = DMAonline::Warden::JWT::Tenant.new({:id => SecureRandom.uuid})
    DMAonline::Warden::JWT::User.new({
        uid: '1234-5678-9012-3456',
        subject_id: 'testing@example.com',
        roles: [
            "tenant_user"
        ]
                                            }, tenant)
  end

  def tenant_user_with_units
    tenant = DMAonline::Warden::JWT::Tenant.new({:id => @tenant_id})
    DMAonline::Warden::JWT::User.new({
                                         uid: '1234-5678-9012-3456',
                                         subject_id: 'testing@example.com',
                                         roles: [
                                             "tenant_user"
                                         ]
                                     }, tenant)
  end

end