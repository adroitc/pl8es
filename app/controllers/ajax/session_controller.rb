class Ajax::SessionController < ApplicationController
  
  def signup
    if !@user && !params.values_at(:name, :email, :password).include?(nil)
      @user = User.create(params.permit(:name, :email, :password))
      
      if @user.errors.count == 0 && !@user.blank?
        download_code = SecureRandom.hex(3).upcase
        while Restaurant.find_by_download_code(download_code).present?
          download_code = SecureRandom.hex(3).upcase
        end
        @user.update_attributes({
          :last_login => DateTime.now,
          :restaurant => Restaurant.create({
            :name => params[:name],
            :location => Location.create(),
            :default_language => Language.find_by_locale(I18n.locale.to_s) ? Language.find_by_locale(I18n.locale.to_s) : Language.first,
            :menuColorTemplate => MenuColorTemplate.first,
            :menuColor => MenuColor.create(),
            :supportedFont => SupportedFont.first,
            :download_code => download_code,
            :background_type => "color"
          })
        })
        
        session[:user_id] = @user.id
        
        render :json => {:status => "success"}
        return
      end
    end
    render :json => {:status => "invalid"}
  end
  
  def signup_name
    if !@user && !params.values_at(:name).include?(nil)
      if !session[:signup]
        session[:signup] = {}
      end
      session[:signup][:name] = params[:name]
      session[:signup][:product_referer] = params[:product_referer]
      
      render :json => {:status => "success", :redirect => signup_restaurant_path}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def signup_restaurant
    if !@user && session[:signup] && !params.values_at(:address, :zip, :city, :country, :latitude, :longitude).include?(nil)
      #google_address = params[:address].gsub(" ","+")+","+params[:zip].gsub(" ","+")+","+params[:city].gsub(" ","+")+","+params[:country].gsub(" ","+")
      #google_url = URI.parse(URI.encode("http://maps.googleapis.com/maps/api/geocode/json?address="+google_address+"&sensor=false&language="+I18n.locale.to_s))
      #google_req = Net::HTTP::Get.new(google_url.request_uri)
      #google_res = Net::HTTP.start(google_url.host, google_url.port) {|http|
      #  http.request(google_req)
      #}
      #google_results = JSON.parse(google_res.body)["results"]
      #if google_results.count == 1 && google_results[0]["geometry"]["location_type"] == "ROOFTOP"
      #  params[:address] = google_results[0]["address_components"].find_all{|item|
      #    item["types"] == ["route"]
      #  }[0]["long_name"]+" "+google_results[0]["address_components"].find_all{|item|
      #    item["types"] == ["street_number"]
      #  }[0]["long_name"]
      #  params[:zip] = google_results[0]["address_components"].find_all{|item|
      #    item["types"] == ["postal_code"]
      #  }[0]["long_name"]
      #  params[:city] = google_results[0]["address_components"].find_all{|item|
      #    item["types"] == ["locality", "political"]
      #  }[0]["long_name"]
      #  params[:country] = google_results[0]["address_components"].find_all{|item|
      #    item["types"] == ["country", "political"]
      #  }[0]["long_name"]
      #
      #  session[:signup][:address] = params[:address]
      #  session[:signup][:zip] = params[:zip]
      #  session[:signup][:city] = params[:city]
      #  session[:signup][:country] = params[:country]
      #  session[:signup][:latitude] = google_results[0]["geometry"]["location"]["lat"].to_f
      #  session[:signup][:longitude] = google_results[0]["geometry"]["location"]["lng"].to_f
      #  
      #  render :json => {:status => "success", :redirect => signup_user_path}
      #  return
      #end

      session[:signup][:address] = params[:address]
      session[:signup][:zip] = params[:zip]
      session[:signup][:city] = params[:city]
      session[:signup][:country] = params[:country]
      session[:signup][:latitude] = params[:latitude]
      session[:signup][:longitude] = params[:longitude]
      
      render :json => {:status => "success", :redirect => signup_user_path}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def signup_user
    if !@user && session[:signup] && !params.values_at(:email, :password).include?(nil)
      @user = User.new(params.permit(:email, :password).merge({
        :password_confirmation => params[:password],
        :last_login => DateTime.now,
        :product_referer => session[:signup][:product_referer]
      }))
      
      if @user.valid? && @user.errors.count == 0
        download_code = SecureRandom.hex(3).upcase
        while Restaurant.find_by_download_code(download_code).present?
          download_code = SecureRandom.hex(3).upcase
        end
        @user.restaurant = Restaurant.create({
          :name => session[:signup][:name],
          :location => Location.create({
            :address => session[:signup][:address],
            :zip => session[:signup][:zip],
            :city => session[:signup][:city],
            :country => session[:signup][:country],
            :latitude => session[:signup][:latitude],
            :longitude => session[:signup][:longitude]
          }),
          :default_language => Language.find_by_locale(I18n.locale.to_s) ? Language.find_by_locale(I18n.locale.to_s) : Language.first,
          :menuColorTemplate => MenuColorTemplate.first,
          :menuColor => MenuColor.create(
            :background => "#000000",
            :bar_background => "#000000",
            :nav_text => "#ffffff",
            :nav_text_active => "#999999"
          ),
          :supportedFont => SupportedFont.first,
          :download_code => download_code,
          :background_type => "color",
          :dailycious_plan => DailyciousPlan.create()
        })
        
        for i in 1..5
          DailyciousCredit.create(
            :restaurant => @user.restaurant
          )
        end
        
        if @device
          @device.update_attributes({
            :user => @user
          })
        end
        if @session
          @session.update_attributes({
            :user => @user
          })
        end
        
        redirect_url = profile_index_path
        
        if @user.product_referer == "d"
          redirect_url = dailycious_path
          
          @user.send_mail(t("email.signup_dailycious_send"), t("email.signup_dailycious_subj"), t("email.signup_dailycious_msg",{:n=>@user.restaurant.name, :e=>@user.email}))
        elsif @user.product_referer == "m"
          redirect_url = menumalist_path
          
          @user.send_mail(t("email.signup_menumalist_send"), t("email.signup_menumalist_subj"), t("email.signup_menumalist_msg",{:n=>@user.restaurant.name,:e=>@user.email,:c=>@user.restaurant.download_code}))
        else
          @user.send_mail(t("email.signup_pl8_send"), t("email.signup_pl8_subj"), t("email.signup_pl8_msg",{:n=>@user.restaurant.name,:e=>@user.email}))
        end
        
        session[:user_id] = @user.id
        
        render :json => {:status => "success", :redirect => redirect_url}
        return
      end
    end
    render :json => {:status => "invalid"}
  end
  
  def login
    if !params.values_at(:email, :password).include?(nil)
      @user = User.find_by_email(params[:email])
      
      if !@user.blank? && @user.authenticate(params[:password])
        @user.update_attributes({
          :last_login => DateTime.now
        })
        
        if @device
          @device.update_attributes({
            :user => @user
          })
        end
        if @session
          @session.update_attributes({
            :user => @user
          })
        end
        
        session[:user_id] = @user.id
        if @user.isAdmin
          session[:admin_id] = @user.id
        end
        
        redirect_url = profile_index_path
        if params[:product_referer] == "d"
          redirect_url = dailycious_path
        elsif params[:product_referer] == "m"
          redirect_url = menumalist_path
        end
        
        render :json => {:status => "success", :redirect => redirect_url}
        return
      end
    elsif !params.values_at(:user_id, :reset_token, :password, :password_confirm).include?(nil)
      @user = User.find(params[:user_id])
      
      if !@user.blank? && @user.reset_token == params[:reset_token] && @user.reset_date < DateTime.now+24.hours
        @user.password = params[:password]
        @user.password_confirmation = params[:password_confirm]
        @user.save
        @user.update_attributes({
          :last_login => DateTime.now
        })
        
        if @device
          @device.update_attributes({
            :user => @user
          })
        end
        if @session
          @session.update_attributes({
            :user => @user
          })
        end
        
        session[:user_id] = @user.id
        if @user.isAdmin
          session[:admin_id] = @user.id
        end
        
        render :json => {:status => "success", :redirect => profile_index_path}
        return
      end
    end
    render :json => {:status => "invalid"}
  end
  
  def login_forgot
    if !params.values_at(:email).include?(nil)
      @user = User.find_by_email(params[:email])
      
      token = SecureRandom.hex(64)
      
      @user.update_attributes({
        :reset_token => token,
        :reset_date => DateTime.now
      })
      
      I18n.locale = @user.restaurant.default_language.locale
      @user.send_mail(t("email.password_forgot_send"), t("email.password_forgot_subj"), t("email.password_forgot_msg",{:l=>login_forgot_reset_path(@user.id, token)}))
      
      render :json => {:status => "valid"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
