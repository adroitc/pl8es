class ProfileController < ApplicationController
  
  def index
    if User.loggedIn(session)
      @user = User.find(session[:user_id])
    else
      redirect_to :controller => "login", :action => "index"
    end
  end
  
end
