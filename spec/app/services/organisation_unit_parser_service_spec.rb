require 'spec_helper'
require_relative '../../../app/services/organisation_unit_parser_service'

describe OrganisationUnitParserService do

  before do
    # ParserManager.register_parser 'test', TestParser
  end

  it 'returns parsed data for the specified system' do
    ParserManager.expects(:get_system_parser).returns(stub(:parse => true))
    response = OrganisationUnitParserService.parse 'test', {test: true}
    assert response

  end

  it 'raises no registered parser error when a parser doesnot exist for the requested system' do
    ParserManager.expects(:get_system_parser).returns(nil)
    assert_raises NoRegisteredParser do
      OrganisationUnitParserService.parse 'non_existent_service', {}
    end
  end

end