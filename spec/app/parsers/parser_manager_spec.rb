require 'spec_helper'
require_relative '../../../app/parsers/parser_manager'

describe ParserManager do

  it 'raises no parse method defined error if the parser doesnot define a parse method' do

    assert_raises NoParseMethodDefined do
      ParserManager.register_parser('test', String)
    end

  end

  it 'should store a reference to the parser class when it defines a parser method' do

    ParserManager.register_parser 'test', TestParser

    assert_includes ParserManager.parsers.keys, 'test'

  end

  it 'returns a reference to the class when retrieving a system parser' do

    ParserManager.register_parser 'test', TestParser

    assert_equal TestParser, ParserManager.get_system_parser('test')

  end

end

class TestParser
  def self.parse
    true
  end
end