require 'spec_helper'
require_relative '../../../app/parsers/pure_organisation_unit_parser'

describe PureOrganisationUnitParser do

  before do
    @pure_with_parent = JSON.parse(File.read("#{__dir__}/../../fixtures/parser_samples/pure_with_parent.json"))
    @pure_without_parent = JSON.parse(File.read("#{__dir__}/../../fixtures/parser_samples/pure_without_parent.json"))
  end

  it 'extends from the base organisation unit parser' do

    assert_equal OrganisationUnitParser, PureOrganisationUnitParser.superclass

  end

  it 'returns pure for the system name' do
    assert_equal 'pure', PureOrganisationUnitParser.system_name
  end

  it 'returns nil when body is empty or not present' do

    [nil, "", {}].each do |test_case|
      assert_nil PureOrganisationUnitParser.parse test_case
    end

  end

  it 'returns a hash with the details of organisation unit from the passed in data' do

    response = PureOrganisationUnitParser.parse @pure_with_parent

    assert_instance_of Hash, response

    assert_equal "pure", response[:system_name]
    assert_equal "a5d74309-4d57-4e8c-a90f-6e43bb66b57d", response[:system_id]
    assert_equal "2018-04-11T01:00:27.673000000+01:00", response[:system_modified_at]
    assert_equal "Management School", response[:name]
    assert_equal "Faculty", response[:unit_type]
    assert_equal "e2e90623-299c-4c58-8d46-42d53c288626", response[:parent_system_id]

  end

  it 'returns a hash with the details of organisation unit from the passed in data when the unit has no parent' do

    response = PureOrganisationUnitParser.parse @pure_without_parent

    assert_instance_of Hash, response

    assert_equal "pure", response[:system_name]
    assert_equal "e2e90623-299c-4c58-8d46-42d53c288626", response[:system_id]
    assert_equal "2018-04-11T01:00:21.500000000+01:00", response[:system_modified_at]
    assert_equal "Lancaster University", response[:name]
    assert_equal "University", response[:unit_type]
    assert_nil response[:parent_system_id]

  end

end