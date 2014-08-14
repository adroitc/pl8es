class BeverageController < ApplicationController
  
  def beveragepage
    if @user && BeveragePage.exists?(params[:beverage_page_id]) && BeveragePage.find(params[:beverage_page_id]).restaurant.user == @user
      @beverage_page = BeveragePage.find(params[:beverage_page_id])
    else
      raise ActionController::RoutingError.new("Not Found")
    end
  end
  
  def beveragenavigation
    if @user && BeverageNavigation.exists?(params[:beverage_navigation_id]) && BeverageNavigation.find(params[:beverage_navigation_id]).beverage_page.restaurant.user == @user
      @beverage_navigation = BeverageNavigation.find(params[:beverage_navigation_id])
    else
      raise ActionController::RoutingError.new("Not Found")
    end
  end
  
end
