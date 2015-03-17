class LogoutController < ApplicationController
  
  def index
    if current_user
      reset_session
      redirect_to new_user_session_path
    end
  end
  
end
