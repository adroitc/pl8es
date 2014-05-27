class LogoutController < ApplicationController
  
  def index
    if User.loggedIn(session)
      reset_session
      redirect_to :controller => "login", :action => "index"
    end
  end
  
end
