ENV['RACK_ENV'] ||= 'test'

require_relative '../config/environment'
require_relative '../app/application'

require 'minitest/autorun'
require 'mocha/mini_test'
require 'rack/test'