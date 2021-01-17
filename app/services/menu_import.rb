class MenuImport
  require 'csv'
  attr_accessor :added_items, :deleted_items, :modified_items

  # allowwed csv headers
  ALLOWED_ATTRIBUTES = [:name, :menu_group, :price].freeze

  # class is responsible for importing menu groups and items
  # import object which is having attachment as param
  def self.call(import)
    new(import).import_csv
  end

  def initialize(import)
    @import = import
    @restaurant_id = import.restaurant_id
    @accept_all_valid = import.import_mode
    @error_message = ''
    reset_counts
  end

  def file_path
    ActiveStorage::Blob.service.send(:path_for, @import.csv_file.key)
  end

  def validate_csv

  end

  def import_csv
    begin 
      ActiveRecord::Base.transaction do
        remove_categories
        add_new_categories
        modify_items
      end
    ensure
      @import.added_items = self.added_items
      @import.deleted_items = self.deleted_items
      @import.modified_items = self.modified_items
      @import.import_status = !@error.present?
      @import.import_mode = @accept_all_valid
      @import.save
    end
  end

  # restaurrant
  def restaurant
    @restaurant ||= Restaurant.includes(menu_categories: :menu_items).find(@restaurant_id)
  end

  # category names in the csv file
  def given_menu_category_keys
    @menu_categories ||= menu_items.keys
  end

  # current_caegory_names
  def current_category_keys
    current_categories.pluck(:name)
  end

  # the keys newly aded in the csv file
  def new_category_keys
    given_menu_category_keys - current_category_keys 
  end

  # keys not present in the csv file
  def deleted_category_keys
    current_category_keys - given_menu_category_keys
  end

  # the modified categoriesin the csv file
  def categories_to_update
    keys = current_category_keys - deleted_category_keys
    MenuCategory.where(name: keys).includes(:menu_items)
  end

  # current categories of restaurant
  def current_categories
    @current_categories ||= restaurant.menu_categories
  end

  # all items in the csv as key-pair
  def menu_items
    @menu_items ||= fetch_items
  end

  private

  # read rows from csv and return as hash of key values
  def fetch_items
    category_attributes = HashWithIndifferentAccess.new {|hash, key| hash[key] = [] }
    header = :default
    CSV.foreach(file_path, headers: true, header_converters: :symbol) do |row|
      header = row[:menu_group].present? ? row[:menu_group] : header
      row[:price] = row[:price].to_f if row[:price]
      row_hash = row.to_h.select { |key, value| ALLOWED_ATTRIBUTES.include?(key)}
      category_attributes[header] << row_hash.except(:menu_group) if row[:name].present?
    end
    category_attributes
  end

  # for iinitialize and also used to reset counts in case of errors
  def reset_counts
    self.added_items = 0
    self.deleted_items = 0
    self.modified_items = 0
  end

  # delete removed categories and its dependent items
  def remove_categories
    removed_categories = restaurant.menu_categories.where(name: deleted_category_keys)
    removed_categories.each do |category|
      category_items_count = category.menu_items.count
      if category.destroy
        self.deleted_items += category_items_count 
      else
        check_and_accept_valid
      end
    end
  end

  # add new categories and items
  def add_new_categories
    new_category_keys.each do |key|
      menu_category = restaurant.menu_categories.build(name: key)
      items = menu_category.menu_items.build(menu_items[key])
      if menu_category.save
        self.added_items += items.count
      else
        check_and_accept_valid
      end
    end
  end

  # during modify check item present in the csv else delete that item
  def delete_items
    deleted_item_names = @all_items.pluck(:name) - @given_items.pluck(:name)
    deleted_items = @category.menu_items.where(name: deleted_item_names)
    deleted_items.each do |del_item|
      if del_item.destroy
        self.deleted_items += 1
      else
        check_and_accept_valid
      end
    end
  end

  # collects the newly added and deleted items and do the
  # respective operations
  def modify_items
    categories_to_update.each do |category|
      @category = category
      @given_items = menu_items[category.name]
      @all_items = category.menu_items
      delete_items
      add_or_modify_items
    end
  end

  # check each row and if new record then create else updates
  def add_or_modify_items
    @given_items.each do |item|
      menu_item = @category.menu_items.where(name: item[:name]).first_or_initialize
      if menu_item.new_record?
        menu_item.attributes = item
        if menu_item.save
          self.added_items += 1
        else
          check_and_accept_valid
        end
      else
        unless (menu_item.syncable_properties.symbolize_keys == item)
          if menu_item.update(item)
            self.modified_items += 1 
          else
            check_and_accept_valid
          end
        end
      end
    end
  end

  # check and if any error then roll back all migrations based on the 
  # import type
  def check_and_accept_valid
    if @accept_all_valid
      reset_counts
      raise ActiveRecord::Rollback
    end
  end
  
end