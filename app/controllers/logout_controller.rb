class LogoutController < ApplicationController
  
  def index
    if @user
      reset_session
      redirect_to login_index_path
    end
  end
  
end
