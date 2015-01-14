class ProfileController < ApplicationController
  
  def index
    if !@user
      redirect_to login_index_path
    end
  end
  
  def public
    if Restaurant.exists?(params[:restaurant_id])
      @visit_restaurant = Restaurant.find(params[:restaurant_id])
    else
      raise ActionController::RoutingError.new("Not Found")
    end
  end
  
end
