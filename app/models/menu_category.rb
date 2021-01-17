class MenuCategory < ApplicationRecord
  belongs_to :restaurant
  has_many :menu_items, dependent: :destroy
  validates :name, uniqueness: {scope: :restaurant_id}, presence: true

end
