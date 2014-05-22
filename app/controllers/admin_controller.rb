class AdminController < ApplicationController
  
  def index
    if User.loggedIn(session)
      @user = User.find(session[:user_id])
    else
      redirect_to :controller => "login", :action => "index"
    end
  end
  
  def users
    if User.loggedIn(session)
      @user = User.find(session[:user_id])
    else
      redirect_to :controller => "login", :action => "index"
    end
  end
  
  def fonts
    if User.loggedIn(session)
      @user = User.find(session[:user_id])
    else
      redirect_to :controller => "login", :action => "index"
    end
  end
  
  def categories
    if User.loggedIn(session)
      @user = User.find(session[:user_id])
    else
      redirect_to :controller => "login", :action => "index"
    end
  end
  
  def menulabels
    if User.loggedIn(session)
      @user = User.find(session[:user_id])
    else
      redirect_to :controller => "login", :action => "index"
    end
  end
  
  def menucolortemplates
    if User.loggedIn(session)
      @user = User.find(session[:user_id])
    else
      redirect_to :controller => "login", :action => "index"
    end
  end
  
end
