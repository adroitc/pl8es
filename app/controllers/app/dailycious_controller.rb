class App::DailyciousController < ApplicationController
  
  skip_before_action  :verify_authenticity_token
  
  def signup
    if @device && !current_user && !params.values_at(:name, :address, :zip, :city, :country, :email, :password).include?(nil)
      current_user = User.new(params.permit(:email, :password).merge({
        :password_confirmation => params[:password],
        :last_login => DateTime.now,
        :product_referer => "d"
      }))
      download_code = SecureRandom.hex(3).upcase
      while Restaurant.find_by_download_code(download_code).present?
        download_code = SecureRandom.hex(3).upcase
      end
      restaurant = Restaurant.new(params.permit(:name, :logo_image).merge({
        :user => current_user,
        :default_language => Language.first,
        :download_code => download_code,
        :background_type => "color"
      }))
      address = Location.validate_address(params.permit(:address, :zip, :city, :country))
      
      if current_user.valid? && current_user.errors.count == 0 && restaurant.valid? && restaurant.errors.count == 0 && address != nil
        current_user.save
        restaurant.save
        restaurant.update_attributes({
          :location => Location.create(address)
        })
        
        if @device
          @device.update_attributes({
            :user => current_user
          })
        end
        if @session
          @session.update_attributes({
            :user => current_user
          })
        end
        
        current_user.restaurant.logo_image.set_crop_values_for_instance(params.permit(:logo_image, :logo_image_crop_w, :logo_image_crop_h, :logo_image_crop_x, :logo_image_crop_y))
        
        current_user.send_mail(t("email.signup_dailycious_send"), t("email.signup_dailycious_subj"), t("email.signup_dailycious_msg",{:n=>current_user.restaurant.name, :e=>current_user.email}))

        session[:user_id] = current_user.id
        
        render :partial => "login"
        return
      end
      render :json => {
        :token => @session.token,
        :status => "invalid",
        :errors => {
          :user => current_user.errors.messages,
          :restaurant => restaurant.errors.messages,
          :location => {
            :address => address == nil ? ["is invalid"] : []
          }
        }
      }
      return
    end
    render :json => {
      :token => @session.token,
      :status => "invalid"
    }
  end
  
  def login
    if @device && !params.values_at(:email, :password).include?(nil)
      current_user = User.find_by_email(params[:email])
      
      if !current_user.blank? && current_user.authenticate(params[:password])
        
        if @device
          @device.update_attributes({
            :user => current_user
          })
        end
        if @session
          @session.update_attributes({
            :user => current_user
          })
        end
        
        session[:user_id] = current_user.id
        
        render :partial => "login"
        return
      end
      
      render :json => {
        :token => @session.token,
        :status => "invalid",
        :errors => {
          :user => {
            :email_password => ["invalid"]
          }
        }
      }
      return
    elsif @device && current_user
      
      render :partial => "login"
      return
    end
    render :json => {
      :token => @session.token,
      :status => "invalid",
      :p => params
    }
  end
  
  def profile
    if @device && current_user && !params.values_at(:name, :address, :zip, :city, :country).include?(nil)
      address = Location.validate_address(params.permit(:address, :zip, :city, :country))
      
      current_user.restaurant.attributes = params.permit(:name)
      if current_user.restaurant.save && current_user.restaurant.errors.count == 0 && address != nil
        current_user.restaurant.update_attributes(params.permit(:name, :logo_image))
        current_user.restaurant.location.update_attributes(address)
        current_user.restaurant.logo_image.set_crop_values_for_instance(params.permit(:logo_image))
        
        render :partial => "login"
        return
      end
    end
    render :json => {
      :token => @session.token,
      :status => "invalid",
      :errors => {
        :restaurant => current_user.restaurant.errors,
        :location => {
          :address => address == nil ? ["is invalid"] : []
        }
      }
    }
  end
  
  def defaults
    if @device
      render :partial => "defaults"
      return
    end
    render :json => {:token => @session.token, :status => "invalid"}
  end
  
  def useragreement
    if @device
      render :partial => "useragreement"
      return
    end
    render :json => {:token => @session.token, :status => "invalid"}
  end
  
  def user
    if @device && !params.values_at(:q).include?(nil) && Restaurant.exists?(params[:q])
      @req_location = Restaurant.find(params[:q]).location
      
      render :partial => "user"
      return
    end
    render :json => {:token => @session.token, :status => "invalid"}
  end
  
end
