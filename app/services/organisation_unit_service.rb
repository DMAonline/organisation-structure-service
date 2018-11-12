require_relative '../models/organisation_unit'

class OrganisationUnitService

  def self.create_ou params

    ou = OrganisationUnit.create(params)

    !ou.errors.any?

  end

  def self.link_ou_to_parent params

    raise NoParentSystemIdSpecified unless params[:parent_system_id].present?

    ou = OrganisationUnit.where(system_id: params[:system_id], tenant_id: params[:tenant_id]).first

    return nil unless ou.present?

    parent_ou = OrganisationUnit.where(system_id: params[:parent_system_id], tenant_id: params[:tenant_id]).first

    return nil unless parent_ou.present?

    ou.parent_id = parent_ou.id
    ou.save

  end

end

class NoParentSystemIdSpecified < StandardError
end