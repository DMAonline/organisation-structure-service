class AddSourceSystemAttributesToOrganisationUnit < ActiveRecord::Migration[5.2]
  def change
    add_column :organisation_units, :system_id, :string
    add_column :organisation_units, :system_name, :string
    add_column :organisation_units, :system_modified_at, :timestamp
  end
end
