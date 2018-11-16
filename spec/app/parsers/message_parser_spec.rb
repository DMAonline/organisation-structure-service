require 'spec_helper'
require_relative '../../../app/parsers/message_parser'

describe MessageParser do

  it 'raises empty message exception if initialised with empty body' do

    ["", {}, nil].each do |empty_message|
      assert_raises EmptyMessage do
        MessageParser.new empty_message
      end
    end

  end

  it 'raises no system specified when message has no system object' do

    mp = MessageParser.new(JSON.parse(File.read("#{__dir__}/../../fixtures/messages/no_system_object.json")))

    assert_raises NoSystemSpecified do
      mp.get_system_type
    end

  end

  it 'raises no system specified when message has no system type set' do

    mp = MessageParser.new(JSON.parse(File.read("#{__dir__}/../../fixtures/messages/no_system_type.json")))

    assert_raises NoSystemSpecified do
      mp.get_system_type
    end

  end

  it 'raises no tenant id specified when message has no tenant object' do

    mp = MessageParser.new(JSON.parse(File.read("#{__dir__}/../../fixtures/messages/no_tenant_object.json")))

    assert_raises NoTenantIDSpecified do
      mp.get_tenant_id
    end

  end

  it 'raises no tenant id specified when message has no tenant id set' do

    mp = MessageParser.new(JSON.parse(File.read("#{__dir__}/../../fixtures/messages/no_tenant_id.json")))

    assert_raises NoTenantIDSpecified do
      mp.get_tenant_id
    end

  end

  it 'raises no message data when message has no data object' do

    mp = MessageParser.new(JSON.parse(File.read("#{__dir__}/../../fixtures/messages/no_data.json")))

    assert_raises NoMessageData do
      mp.get_data
    end

  end


  it 'returns system type when valid message' do

    mp = MessageParser.new(JSON.parse(File.read("#{__dir__}/../../fixtures/messages/ingest_organisation_unit.json")))

    assert_equal 'pure', mp.get_system_type

  end

  it 'returns tenant id when valid message' do

    mp = MessageParser.new(JSON.parse(File.read("#{__dir__}/../../fixtures/messages/ingest_organisation_unit.json")))

    assert_equal '6cd19d93-9eff-443f-be67-711cf90e0af4', mp.get_tenant_id

  end

  it 'return message data when valid message' do

    mp = MessageParser.new(JSON.parse(File.read("#{__dir__}/../../fixtures/messages/ingest_organisation_unit.json")))

    assert mp.get_data

    assert_equal "a5d74309-4d57-4e8c-a90f-6e43bb66b57d", mp.get_data["uuid"]

  end

end