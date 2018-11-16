require_relative '../services/organisation_unit_parser_service'
require_relative '../services/organisation_unit_service'
require_relative '../../app/parsers/message_parser'

class IngestOrganisationUnitWorker

  include Shoryuken::Worker

  shoryuken_options queue: ENV['PROCESS_QUEUE_NAME'], auto_delete: true, body_parser: :json

  def perform _sqs_message, body

    begin

      message = MessageParser.new(body)

      TenantManager.init_tenant message.get_tenant_id

      system = message.get_system_type
      data = message.get_data

      ingest_organisation_unit system, data

    ensure
      TenantManager.unset_tenant
    end

  end

  def ingest_organisation_unit system, data

    ou = OrganisationUnitParserService.parse system, data

    params = ou.dup.keep_if { |key, _value| key != :parent_system_id }

    if OrganisationUnitService.ou_system_id_exists? ou[:system_name], ou[:system_id]
      raise FailedToUpdateOU unless OrganisationUnitService.update_ou params
    else
      raise FailedToCreateOU unless OrganisationUnitService.create_ou params
    end

  end

end

class FailedToCreateOU < StandardError
  end

class FailedToUpdateOU < StandardError
end

