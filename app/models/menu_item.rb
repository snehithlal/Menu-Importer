class MenuItem < ApplicationRecord
  belongs_to :menu_category
  validates :name, uniqueness: {scope: :menu_category_id}, presence: true
  validates :price, presence: true

  # the attributes which can be synced via import
  def syncable_properties
    attributes.except('id', 'menu_category_id', 'created_at', 'updated_at')
  end

end
