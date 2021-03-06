require_relative '../services/organisation_unit_parser_service'
require_relative '../services/organisation_unit_service'
require_relative '../../app/parsers/message_parser'
require_relative 'middleware/tenant_scope_middleware'

class LinkOrganisationUnitWorker

  include Shoryuken::Worker

  shoryuken_options queue: ENV['LINK_ORG_UNITS_QUEUE_NAME'],
                    auto_delete: true,
                    body_parser: :json

  server_middleware do |chain|
    chain.add TenantScopeMiddleware
  end

  def perform _sqs_message, body

    message = MessageParser.new(body)

    system = message.get_system_type
    data = message.get_data

    link_organisation_unit system, data

  end

  def link_organisation_unit system, data

    ou = OrganisationUnitParserService.parse system, data

    begin
      response = OrganisationUnitService.link_ou_to_parent ou.dup
      raise FailedToLinkOU unless response.nil? || response
    rescue NoParentSystemIdSpecified
      # Rescue as this is an internal error of not being able to link when no parent id is specified
    end

  end

end

class FailedToLinkOU < StandardError
end