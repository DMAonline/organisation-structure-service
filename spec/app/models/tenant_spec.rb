require 'spec_helper'
require_relative '../../../app/models/tenant'

describe Tenant do

  before do
    @tenant = Tenant.new SecureRandom.uuid
  end

  it 'responds to id method' do

    assert @tenant.id

  end

end