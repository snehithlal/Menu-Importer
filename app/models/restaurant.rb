class Restaurant < ApplicationRecord
  has_many :menu_categories, dependent: :destroy
  has_many :menu_items, through: :menu_categories
  has_many :imports
  validates :name, uniqueness: true, presence: true
end
