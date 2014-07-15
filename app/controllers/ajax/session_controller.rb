class Ajax::SessionController < ApplicationController
  
  def signup
    if !@user && !params.values_at(:name, :email, :password).include?(nil)
      @user = User.create(params.permit(:name, :email, :password))
      
      if @user.errors.count == 0 && !@user.blank?
        download_code = SecureRandom.hex(3).upcase
        while User.find_by_download_code(download_code).present?
          download_code = SecureRandom.hex(3).upcase
        end
        @user.update_attributes({
          :last_login => DateTime.now,
          :background_type => "color",
          :restaurant => Restaurant.create({
            :location => Location.create(),
            :default_language => Language.first,
            :menuColorTemplate => MenuColorTemplate.first,
            :menuColor => MenuColor.create(),
            :supportedFont => SupportedFont.first,
            :download_code => download_code
          })
        })
        
        session[:user_id] = @user.id
        
        render :json => {:status => "success"}
        return
      end
    end
    render :json => {:status => "invalid"}
  end
  
  def login
    if !params.values_at(:email, :password).include?(nil)
      @user = User.find_by_email_and_password(params[:email],params[:password])
      
      if !@user.blank?
        @user.update_attributes({
          :last_login => DateTime.now
        })
        session[:user_id] = @user.id
        if @user.isAdmin
          session[:admin_id] = @user.id
        end
        
        render :json => {:status => "success"}
        return
      end
    end
    render :json => {:status => "invalid"}
  end
  
end
