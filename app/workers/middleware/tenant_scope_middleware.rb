require_relative '../../../app/parsers/message_parser'

class TenantScopeMiddleware
  def call(worker_instance, queue, sqs_msg, body)
    message = MessageParser.new(body)
    TenantManager.init_tenant message.get_tenant_id
    yield
  ensure
    TenantManager.unset_tenant
  end
end