class RestaurantsController < ApplicationController

  def index
    @restaurants = Restaurant.all
  end

  def restaurant_details
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  
  def new_import
    @restaurant = Restaurant.find(params[:id])
  end

  def import_csv
    @restaurant = Restaurant.find(params[:id])
    @import = @restaurant.imports.new(import_mode: params[:accept_all_valid], csv_file: params[:csv_file])
    if @import.save
      MenuImport.call(@import)
    else
      flash[:error] = @import.errors.full_messages
    end
    redirect_to action: 'new_import'
  end

  def list_menu_items
    @menu_category = MenuCategory.find(params[:item_id])
  end
  
end
