require_relative 'models/tenant'

class TenantManager

  @@tenant = nil

  def self.current_tenant
    @@tenant
  end

  def self.current_tenant_id
    @@tenant.present? ? @@tenant.id : nil
  end

  def self.unset_tenant
    @@tenant = nil
  end

  def self.init_tenant tenant_id
    @@tenant = Tenant.new tenant_id
  end

  private_class_method :new

end