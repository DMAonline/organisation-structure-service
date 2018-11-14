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

end