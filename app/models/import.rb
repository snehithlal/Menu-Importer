class Import < ApplicationRecord

  has_one_attached :csv_file
  belongs_to :restaurant
  validates :csv_file, attached: true, content_type: 'text/csv'

  # import summary for the last import
  def import_summary
    if (import_mode && !import_status)
      "Import Failed And all imports cancelled"
    else
      messages = []
      messages << "#{added_items.to_i} items added" 
      messages << "#{modified_items.to_i} items modified" 
      messages << "#{deleted_items.to_i} items deleted" 
      messages.join(', ')
    end
  end

end
