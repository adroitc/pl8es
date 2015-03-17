class LoginController < ApplicationController
  
  def index
    if current_user
      redirect_to profile_index_path
    end
  end
  
  def forgot
    if current_user
      redirect_to profile_index_path
    end
  end
  
  def forgot_reset
    if !params.values_at(:user_id, :reset_token).include?(nil)
      current_user = User.find(params[:user_id])
      if !(!current_user.blank? && current_user.reset_token == params[:reset_token] && current_user.reset_date < DateTime.now+24.hours && current_user.updated_at < current_user.reset_date+1.seconds)
        raise ActionController::RoutingError.new("Not Found")
      end
    end
  end
   
end
