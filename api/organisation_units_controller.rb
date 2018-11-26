require_relative 'base_controller'
require_relative 'middleware/tenant_scope'
require_relative 'middleware/authentication'
require_relative '../app/models/organisation_unit'

module Api

  class OrganisationUnitsController < BaseController

    use Middleware::Authentication
    use Middleware::TenantScope

    get '/' do

      filter_options = params.slice(:type, :parent_id, :system_id, :system)

      if filter_options.present?
        organisation_units = OrganisationUnit.filter(filter_options)
      else
        organisation_units = OrganisationUnit.all
      end

      status 200
      json_response = {organisation_units: organisation_units}
      json json_response

    end

    get '/:id' do

      begin
        org_unit = OrganisationUnit.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        halt 404, json({status: {code: 404, message: 'No Organisation Unit found for specified id'}})
      end

      status 200
      json_response = {organisation_unit: org_unit}
      json json_response

    end

  end

end