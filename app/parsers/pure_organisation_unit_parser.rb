require_relative 'organisation_unit_parser'

class PureOrganisationUnitParser < OrganisationUnitParser

  def self.parse body

    return nil unless body.present?

    system_name = self.system_name
    system_id = body["uuid"]
    system_modified_at = body["modified_at"]["^t"]
    name = body["name"]
    parent_system_id = body["parent"].present? ? body["parent"]["uuid"] : nil
    unit_type = body["type"]

    {
        system_name: system_name,
        system_id: system_id,
        system_modified_at: system_modified_at,
        name: name,
        unit_type: unit_type,
        parent_system_id: parent_system_id
    }

  end

  def self.system_name
    'pure'
  end

end