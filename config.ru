require 'raven'

Raven.configure do |config|
  config.dsn = ENV['SENTRY_DSN']
end

use Raven::Rack

require 'sinatra/base'

require_relative 'config/environment'
require_relative 'app/application'

Dir.glob('./api/*.rb').each {|file| require file}

map '/' do
  run Api::OrganisationUnitsController
end