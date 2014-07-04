class MenumalistController < ApplicationController
  
  def index
    if !@user
      redirect_to :controller => "login", :action => "index"
    end
  end
  
  def categories
    if @user && @user.menus.exists?(params[:menu_id])
      @menu = @user.menus.find(params[:menu_id])
    else
      raise ActionController::RoutingError.new("Not Found")
    end
  end
  
  def category
    if @user && @user.menus.exists?(params[:menu_id]) && @user.menus.find(params[:menu_id]).navigations.exists?(params[:navigation_id])
      @navigation = @user.menus.find(params[:menu_id]).navigations.find(params[:navigation_id])
    else
      raise ActionController::RoutingError.new("Not Found")
    end
  end
  
end
