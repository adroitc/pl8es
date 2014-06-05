class LogoutController < ApplicationController
  
  def index
    if @user
      reset_session
      redirect_to :controller => "login", :action => "index"
    end
  end
  
end
