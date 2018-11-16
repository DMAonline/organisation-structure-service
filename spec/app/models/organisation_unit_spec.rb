require 'spec_helper'
require_relative '../../../app/models/organisation_unit'

describe OrganisationUnit do

  before do
    @tenant_id = SecureRandom.uuid
    TenantManager.init_tenant @tenant_id
    @institution = OrganisationUnit.create({
        tenant_id: @tenant_id,
        name: 'Lancaster University',
        unit_type: 'University',
        system_id: 'e2e90623-299c-4c58-8d46-42d53c288626',
        system_name: 'pure',
        system_modified_at: '2018-04-11T01:00:21.500000000+01:00'
    })
    @faculty = OrganisationUnit.new({
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
    @faculty3 = OrganisationUnit.create({
        tenant_id: @tenant_id,
        name: 'Faculty of Science & Technology',
        unit_type: 'Faculty',
        parent_id: @institution.id,
        system_id: 'a5d74309-4d57-4e8c-a90f-6e43bb66b84c',
        system_name: 'pure',
        system_modified_at: '2018-04-11T01:00:14.580000000+01:00'
    })
  end

  after do
    TenantManager.unset_tenant
  end

  it 'is a valid organisation unit (faculty)' do
    assert @faculty.valid?
  end

  it 'is invalid when tenant id is empty' do
    check_invalid_when_empty 'tenant_id'
  end

  it 'is invalid when system id is empty' do
    check_invalid_when_empty 'system_id'
  end

  it 'is invalid when system name is empty' do
    check_invalid_when_empty 'system_name'
  end

  it 'is invalid when system modified at is empty' do
    check_invalid_when_empty 'system_modified_at'
  end

  it 'is invalid when name is empty' do
    check_invalid_when_empty 'name'
  end

  it 'is invalid when unit type is empty' do
    check_invalid_when_empty 'unit_type'
  end

  it 'is invalid for 2 organisation units in the same tenant to have the same system id' do
    @faculty.system_id = @institution.system_id
    refute @faculty.valid?
  end

  it 'returns an instance of the parent class when parent id is specified' do
    assert @faculty2.parent_id.present?
    assert @faculty2.parent.present?
    assert_instance_of OrganisationUnit, @faculty2.parent
    assert_equal @faculty2.parent.id, @faculty2.parent_id
  end

  it 'returns a collection of child units to the parent' do
    assert @institution.children.present?
    assert_equal @institution.children.count, 2
    assert_includes @institution.children, @faculty2
    assert_includes @institution.children, @faculty3
  end

end

def check_invalid_when_empty attribute_name

  empty_values = [nil, '']

  empty_values.each do |value|
    @institution.send("#{attribute_name}=", value)
    refute @institution.valid?
  end

end