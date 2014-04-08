class MenumalistController < ApplicationController
  
  def index
    if User.loggedIn(session)
      @user = User.find(session[:user_id])
    else
      redirect_to :controller => "login", :action => "index"
    end
  end
  
  def categories
    if User.loggedIn(session)
      @user = User.find(session[:user_id])
      
      if @user.menus.exists?(params[:menu_id])
        @menu = @user.menus.find(params[:menu_id])
      else
        raise ActionController::RoutingError.new("Not Found")
      end
    else
      redirect_to :controller => "login", :action => "index"
    end
  end
  
end
