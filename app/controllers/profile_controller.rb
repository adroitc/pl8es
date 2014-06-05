class ProfileController < ApplicationController
  
  def index
    if !@user
      redirect_to :controller => "login", :action => "index"
    end
  end
  
  def edit
    if !@user
      redirect_to :controller => "login", :action => "index"
    end
  end
  
end
