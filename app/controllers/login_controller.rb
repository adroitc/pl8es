class LoginController < ApplicationController
  
  def index
    if @user
      redirect_to profile_index_path
    end
  end
  
  def forgot
    if @user
      redirect_to profile_index_path
    end
  end
  
  def forgot_reset
    if !params.values_at(:user_id, :reset_token).include?(nil)
      @user = User.find(params[:user_id])
      if !(!@user.blank? && @user.reset_token == params[:reset_token] && @user.reset_date < DateTime.now+24.hours && @user.updated_at < @user.reset_date+1.seconds)
        raise ActionController::RoutingError.new("Not Found")
      end
    end
  end
   
end
