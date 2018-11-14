require_relative '../../app/parsers/parser_manager'
require_relative '../../app/parsers/pure_organisation_unit_parser'

{
    'pure' => PureOrganisationUnitParser
}.each do |system, parser|
 ParserManager.register_parser(system, parser)
end

