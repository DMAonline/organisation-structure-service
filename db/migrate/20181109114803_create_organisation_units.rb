class CreateOrganisationUnits < ActiveRecord::Migration[5.2]
  def change
    create_table :organisation_units, id: :uuid do |t|
      t.string :tenant_id
      t.string :name
      t.string :unit_type
      t.string :parent_id
      t.timestamps
    end
  end
end
