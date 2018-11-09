class OrganisationUnit < ActiveRecord::Base

  validates :tenant_id, presence: true

  validates :system_id, presence: true, uniqueness: { scope: :tenant_id, message: 'should be unique to the tenant' }
  validates :system_modified_at, presence: true
  validates :system_name, presence: true

  validates :name, presence: true
  validates :unit_type, presence: true

  belongs_to :parent, class_name: 'OrganisationUnit', optional: true
  has_many :children, class_name: 'OrganisationUnit', foreign_key: 'parent_id'

end