class LoginController < ApplicationController
  
  def index_post
    if !params.values_at(:email, :password).include?(nil)
      @user = User.find_by_email_and_password(params[:email],params[:password])
      
      if !@user.blank?
        render :text => {:login_status => "success"}.to_json.to_s
        return
      end
    end
    render :text => {:login_status => "invalid"}.to_json.to_s
  end
  
end
