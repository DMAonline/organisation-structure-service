class AddUnqiueIndexToOrganisationUnits < ActiveRecord::Migration[5.2]
  def change
    add_index :organisation_units, [:system_name, :system_id, :tenant_id], unique: true, name: 'index_organisation_units_on_tenant_unique_system_id'
  end
end
