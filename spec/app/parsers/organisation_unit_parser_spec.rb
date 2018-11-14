require 'spec_helper'
require_relative '../../../app/parsers/organisation_unit_parser'

describe OrganisationUnitParser do

  it 'raises not implemented for parse method' do

    assert_raises NotImplementedError do
      OrganisationUnitParser.parse nil
    end

  end

  it 'raises not implemented for system name method' do

    assert_raises NotImplementedError do
      OrganisationUnitParser.system_name
    end

  end

end