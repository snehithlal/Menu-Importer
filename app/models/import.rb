class Import < ApplicationRecord

  has_one_attached :csv_file
  belongs_to :restaurant

  # after_commit :update_csv_file


  def update_csv_file
    import = MenuImport.new(self)
    p import
    p import.file_path
    p import.menu_items
    # import.accept_if_all_valid
  end

end
