class LogoutController < ApplicationController
  
  def index
    if current_user
      reset_session
      redirect_to login_index_path
    end
  end
  
end
