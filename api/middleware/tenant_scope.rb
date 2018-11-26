require_relative 'helpers/warden_helper'

module Api

  module Middleware

    class TenantScope

      include WardenHelper

      def initialize app
        @app = app
      end

      def call env

        current_tenant = warden_from_env(env).user.tenant

        TenantManager.init_tenant current_tenant.id

        @app.call env

      ensure

        TenantManager.unset_tenant

      end

    end

  end

end