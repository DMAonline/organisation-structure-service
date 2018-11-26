module Api

  module Middleware

    module WardenHelper

      def warden_from_env env
        env['warden']
      end

    end

  end

end