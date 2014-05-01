class Ajax::DishController < ApplicationController
  
  def dish
    if User.loggedIn(session) && Dish.find(params[:id]) && Dish.find(params[:id]).menu.user == User.find(session[:user_id])
      render :json => {
        :status => "success",
        :dish => JSON.parse(
          Dish.find(params[:id]).to_json(
            :only => [:id, :title],
            :methods => [:image_url, :price_currency]
          )
        )
      }
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
