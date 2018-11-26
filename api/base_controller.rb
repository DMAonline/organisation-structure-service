require 'warden'
require 'DMAonline/Warden/JWT'
require_relative '../app/application'
require_relative 'failure_app'

module Api

  class BaseController < ::Application

    use Warden::Manager do |config|

      config.scope_defaults :default,
                            strategies: [:dmao_jwt],
                            action: '/unauthenticated'

      config.failure_app = FailureApp

      config.jwt do |jwt_config|
        jwt_config.secret ENV['JWT_SECRET']
        jwt_config.issuer ENV['JWT_ISSUER']
        jwt_config.audience ENV['JWT_AUDIENCE']
        jwt_config.custom_claims_attribute ENV['JWT_CUSTOM_CLAIMS_ATTR']
      end

    end

    Warden::Manager.before_failure do |env|
      env['REQUEST_METHOD'] = 'GET'
    end

  end

end