class LoginController < ApplicationController
  
  def index
    if User.loggedIn(session)
      redirect_to :controller => "menumalist", :action => "index"
    end
  end
   
end
