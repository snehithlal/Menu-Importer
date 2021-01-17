class Import < ApplicationRecord

  has_one_attached :csv_file
  belongs_to :restaurant
  validates :csv_file, attached: true

end
