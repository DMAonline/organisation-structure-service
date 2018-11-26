ENV['RACK_ENV'] ||= 'test'

require 'simplecov'

SimpleCov.start do
  add_filter '/config/'
  add_filter '/spec/'
end

require_relative '../config/environment'
require_relative '../app/application'

require 'minitest/autorun'
require 'mocha/minitest'
require 'rack/test'
require 'database_cleaner'


DatabaseCleaner.strategy = :transaction

class MiniTest::Spec

  before :each do
    DatabaseCleaner.start
  end

  after :after do
    DatabaseCleaner.clean
  end

end