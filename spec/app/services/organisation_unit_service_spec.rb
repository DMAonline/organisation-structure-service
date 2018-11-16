require 'spec_helper'
require_relative '../../../app/services/organisation_unit_service'

describe OrganisationUnitService do

  before do
    @ou_params = {}
  end

  it 'returns true if it successfully creates an organisation unit' do

    OrganisationUnit.expects(:create).returns(stub(:errors => stub(:any? => false)))

    assert OrganisationUnitService.create_ou @ou_params

  end

  it 'returns false if it fails to create an organisation unit' do

    OrganisationUnit.expects(:create).returns(stub(:errors => stub(:any? => true)))

    refute OrganisationUnitService.create_ou @ou_params

  end

  it 'raises no parent system id specified when there is no parent system id' do

    params = {
        system_id: SecureRandom.uuid,
        tenant_id: SecureRandom.uuid
    }

    assert_raises NoParentSystemIdSpecified do
      OrganisationUnitService.link_ou_to_parent(params)
    end

  end

  it 'returns nil if the organisation unit doesnot exist' do

    params = {
        system_id: SecureRandom.uuid,
        tenant_id: SecureRandom.uuid,
        parent_system_id: SecureRandom.uuid
    }

    OrganisationUnit.expects(:where).with(system_id: params[:system_id], tenant_id: params[:tenant_id]).returns([])

    refute OrganisationUnitService.link_ou_to_parent(params)

  end

  it 'returns nil if the parent organisation unit doesnot exist' do

    params = {
        system_id: SecureRandom.uuid,
        tenant_id: SecureRandom.uuid,
        parent_system_id: SecureRandom.uuid
    }

    OrganisationUnit.expects(:where).with(system_id: params[:system_id], tenant_id: params[:tenant_id]).returns(stub(:first => true))

    OrganisationUnit.expects(:where).with(system_id: params[:parent_system_id], tenant_id: params[:tenant_id]).returns([])

    refute OrganisationUnitService.link_ou_to_parent(params)

  end

  it 'returns false if it fails to update the parent id on the organisation unit' do

    params = {
        system_id: SecureRandom.uuid,
        tenant_id: SecureRandom.uuid,
        parent_system_id: SecureRandom.uuid
    }

    ou = stub(:parent_id= => true)

    OrganisationUnit.expects(:where).with(system_id: params[:system_id], tenant_id: params[:tenant_id]).returns(stub(:first => ou))

    OrganisationUnit.expects(:where).with(system_id: params[:parent_system_id], tenant_id: params[:tenant_id]).returns(stub(:first => stub(:id => 1234)))

    ou.expects(:save).returns false

    refute OrganisationUnitService.link_ou_to_parent(params)

  end



  it 'returns true if it updates the parent id on the organisation unit' do

    params = {
        system_id: SecureRandom.uuid,
        tenant_id: SecureRandom.uuid,
        parent_system_id: SecureRandom.uuid
    }

    ou = stub(:parent_id= => true)

    OrganisationUnit.expects(:where).with(system_id: params[:system_id], tenant_id: params[:tenant_id]).returns(stub(:first => ou))

    OrganisationUnit.expects(:where).with(system_id: params[:parent_system_id], tenant_id: params[:tenant_id]).returns(stub(:first => stub(:id => 1234)))

    ou.expects(:save).returns true

    assert OrganisationUnitService.link_ou_to_parent(params)

  end

  it 'returns nil if the ou cannot be found by the system and system id' do

    system_id = SecureRandom.uuid

    OrganisationUnit.expects(:where).with(system_id: system_id, system_name: 'pure').returns(stub(:first => nil))

    refute OrganisationUnitService.get_ou_by_system_id 'pure', system_id

  end

  it 'returns instance of organisation unit when ou can be found by system and system id' do

    system_id = SecureRandom.uuid

    OrganisationUnit.expects(:where).with(system_id: system_id, system_name: 'pure').returns(stub(:first => OrganisationUnit.new))

    assert_instance_of OrganisationUnit, OrganisationUnitService.get_ou_by_system_id('pure', system_id)

  end

  it 'returns false if ou with system id doesnot exist' do

    system_id = SecureRandom.uuid

    OrganisationUnitService.expects(:get_ou_by_system_id).with('pure', system_id).returns(nil)

    refute OrganisationUnitService.ou_system_id_exists? 'pure', system_id

  end

  it 'returns true if ou with system id does exist' do

    system_id = SecureRandom.uuid

    OrganisationUnitService.expects(:get_ou_by_system_id).with('pure', system_id).returns(OrganisationUnit.new)

    result = OrganisationUnitService.ou_system_id_exists? 'pure', system_id

    assert result

    assert_equal true, result

  end

  it 'raises invalid ou if org unit cannot be found for update' do

    system_id = SecureRandom.uuid

    OrganisationUnitService.expects(:get_ou_by_system_id).with('pure', system_id).returns(nil)

    params = {
        system_name: 'pure',
        system_id: system_id
    }

    assert_raises InvalidOU do
      OrganisationUnitService.update_ou params
    end

  end

  it 'returns false if ou fails to update' do

    org_unit = OrganisationUnit.new
    system_id = SecureRandom.uuid

    params = {
        system_name: 'pure',
        system_id: system_id,
        name: 'New Name'
    }

    OrganisationUnitService.expects(:get_ou_by_system_id).with('pure', system_id).returns(org_unit)

    org_unit.expects(:update).with(params).returns(false)

    refute OrganisationUnitService.update_ou params

  end

  it 'returns true when ou updates' do

    org_unit = OrganisationUnit.new
    system_id = SecureRandom.uuid

    params = {
        system_name: 'pure',
        system_id: system_id,
        name: 'New Name'
    }

    OrganisationUnitService.expects(:get_ou_by_system_id).with('pure', system_id).returns(org_unit)

    org_unit.expects(:update).with(params).returns(true)

    assert OrganisationUnitService.update_ou params

  end

end