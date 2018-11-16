require 'spec_helper'
require_relative '../../app/tenant_manager'

describe TenantManager do

  after do
    TenantManager.unset_tenant
  end

  it 'defaults tenant to be nil' do
    refute TenantManager.current_tenant
  end

  it 'returns nil for current tenant id when tenant is not set' do
    refute TenantManager.current_tenant_id
  end

  it 'sets tenant to an instance of tenant class when initialising' do

    TenantManager.init_tenant SecureRandom.uuid

    assert_instance_of Tenant, TenantManager.current_tenant

  end

  it 'sets the tenant to nil when calling unset tenant' do

    TenantManager.init_tenant SecureRandom.uuid

    assert_instance_of Tenant, TenantManager.current_tenant

    TenantManager.unset_tenant

    refute TenantManager.current_tenant

  end

  it 'returns the tenant id when tenant is set' do

    tenant_id = SecureRandom.uuid

    TenantManager.init_tenant tenant_id

    assert_equal tenant_id, TenantManager.current_tenant_id

  end

  it 'does not allow the tenant manager class to instantiated' do

    assert_raises NoMethodError do
      TenantManager.new
    end

  end

  it 'is thread safe' do

    @tenant_id_1 = SecureRandom.uuid
    @tenant_id_2 = SecureRandom.uuid

    Thread.new do
      TenantManager.init_tenant @tenant_id_1
      assert_equal @tenant_id_1, TenantManager.current_tenant_id
      TenantManager.unset_tenant
      refute TenantManager.current_tenant_id
    end

    Thread.new do
      TenantManager.init_tenant @tenant_id_2
      assert_equal @tenant_id_2, TenantManager.current_tenant_id
      TenantManager.unset_tenant
      refute TenantManager.current_tenant_id
    end

  end

end