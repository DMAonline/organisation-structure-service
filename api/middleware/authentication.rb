require_relative 'helpers/warden_helper'

module Api

  module Middleware

    class Authentication

      include WardenHelper

      def initialize app
        @app = app
      end

      def call env

        warden_from_env(env).authenticate!

        @app.call env

      end

    end

  end

end