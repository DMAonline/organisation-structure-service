require_relative '../models/organisation_unit'

class OrganisationUnitService

  def self.create_ou params

    ou = OrganisationUnit.create(params)

    !ou.errors.any?

  end

  def self.update_ou params

    ou = get_ou_by_system_id params[:system_name], params[:system_id]

    raise InvalidOU unless ou.present?

    ou.update(params)

  end

  def self.ou_system_id_exists? system, id

    ou = get_ou_by_system_id system, id

    ou.present?

  end

  def self.get_ou_by_system_id system, id
    OrganisationUnit.where(system_id: id, system_name: system).first
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

class InvalidOU < StandardError
end