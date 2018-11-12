class ParserManager

  @@parsers = {}

  def self.register_parser system, parser
    raise NoParseMethodDefined unless parser.respond_to? :parse
    @@parsers[system] = parser
  end

  def self.get_system_parser system
    @@parsers[system]
  end

  def self.parsers
    return @@parsers
  end

end

class NoParseMethodDefined < StandardError
end