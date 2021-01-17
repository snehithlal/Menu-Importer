class ImportsController < ApplicationController

  def index
    @restaurants = Restaurant.all
  end

  def new
    @import = Import.new
  end
  
  def create
    @import = Object.new(params[:import])
    if @import.save
      flash[:success] = "Object successfully created"
      redirect_to @import
    else
      flash[:error] = "Something went wrong"
      render 'new'
    end
  end
  

  def import_data
    log = MenuImport.new(params[:csv_file], 35)
    p log.accept_if_all_valid
    # p import_params
  #  p params[:csv_file].class
    # imp = ImportLog.new(params[:csv_file])
    # imp.save
  end

  def import_params
    params.require(:import).permit(:csv_file)
  end
  
end
