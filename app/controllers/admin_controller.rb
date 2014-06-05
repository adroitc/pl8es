class AdminController < ApplicationController
  
  def index
    if !@user
      redirect_to :controller => "login", :action => "index"
    end
  end
  
  def users
    if !@user
      redirect_to :controller => "login", :action => "index"
    end
  end
  
  def fonts
    if !@user
      redirect_to :controller => "login", :action => "index"
    end
  end
  
  def categories
    if !@user
      redirect_to :controller => "login", :action => "index"
    end
  end
  
  def menulabels
    if !@user
      redirect_to :controller => "login", :action => "index"
    end
  end
  
  def menucolortemplates
    if !@user
      redirect_to :controller => "login", :action => "index"
    end
  end
  
end
