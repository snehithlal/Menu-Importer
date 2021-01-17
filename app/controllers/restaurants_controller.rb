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
    @import = @restaurant.imports.create(csv_file: params[:csv_file])
    MenuImport.call(@import)
  end
  
end
