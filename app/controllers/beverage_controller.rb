class BeverageController < ApplicationController
  
  def beveragepages
    if @user && @user.restaurant.beveragePages.exists?(params[:beverage_page_id])
      @beverage_page = @user.restaurant.beveragePages.find(params[:beverage_page_id])
    else
      raise ActionController::RoutingError.new("Not Found")
    end
  end
  
end
