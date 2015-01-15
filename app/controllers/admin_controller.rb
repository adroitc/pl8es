class AdminController < ApplicationController
  
  def index
    if !(@user && @user.isAdmin)
      raise ActionController::RoutingError.new("Not Found")
    end
  end
  
  def languages
    if !(@user && @user.isAdmin)
      raise ActionController::RoutingError.new("Not Found")
    end
  end
  
  def users
    if !(@user && @user.isAdmin)
      raise ActionController::RoutingError.new("Not Found")
    end
  end
  
  def user_switch
    if @user && (@user.isAdmin || (session[:admin_id] && User.exists?(session[:admin_id]) && User.find(session[:admin_id]).isAdmin))
      session[:user_id] = params[:user_id]
      redirect_to profile_index_path
    else
      raise ActionController::RoutingError.new("Not Found")
    end
  end
  
  def tags
    if !(@user && @user.isAdmin)
      raise ActionController::RoutingError.new("Not Found")
    end
  end
  
  def menucolortemplates
    if !(@user && @user.isAdmin)
      raise ActionController::RoutingError.new("Not Found")
    end
  end
  
  def fonts
    if !(@user && @user.isAdmin)
      raise ActionController::RoutingError.new("Not Found")
    end
  end
  
  def ingredients
    if !(@user && @user.isAdmin)
      raise ActionController::RoutingError.new("Not Found")
    end
  end
  
end
