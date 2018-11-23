require_relative 'models/tenant'

class TenantManager

  def self.current_tenant
    Thread.current[:tenant]
  end

  def self.current_tenant_id
    Thread.current[:tenant].present? ? Thread.current[:tenant].id : nil
  end

  def self.unset_tenant
    Thread.current[:tenant] = nil
  end

  def self.init_tenant tenant_id
    Thread.current[:tenant] = Tenant.new tenant_id
  end

  private_class_method :new

end