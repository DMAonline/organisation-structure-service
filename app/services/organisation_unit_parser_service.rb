require_relative '../parsers/parser_manager'

class OrganisationUnitParserService

  def self.parse system, message_data

    parser = ParserManager.get_system_parser(system)

    raise NoRegisteredParser unless parser.present?

    parser.parse(message_data)

  end


end

class NoRegisteredParser < StandardError
end