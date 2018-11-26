require_relative 'concerns/filterable'

class OrganisationUnit < ActiveRecord::Base

  include Filterable

  validates :tenant_id, presence: true

  validates :system_id, presence: true, uniqueness: { scope: [:tenant_id, :system_name], message: 'should be unique to the system and tenant' }
  validates :system_modified_at, presence: true
  validates :system_name, presence: true

  validates :name, presence: true
  validates :unit_type, presence: true

  belongs_to :parent, class_name: 'OrganisationUnit', optional: true
  has_many :children, class_name: 'OrganisationUnit', foreign_key: 'parent_id'

  default_scope { where(tenant_id: TenantManager.current_tenant_id) }

  scope :type, -> (type_id) { where unit_type: type_id }
  scope :parent_id, -> (parent_id) { where parent_id: parent_id }
  scope :system_id, -> (system_id) { where system_id: system_id }
  scope :system, -> (system) { where system_name: system }

end