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
            :default_language => Language.first,
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
      
      render :json => {:status => "success", :redirect => url_for(:controller => "/signup", :action => "restaurant")}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def signup_restaurant
    if !@user && session[:signup] && !params.values_at(:address, :zip, :city, :country).include?(nil)
      google_address = params[:address].gsub(" ","+")+","+params[:zip].gsub(" ","+")+","+params[:city].gsub(" ","+")+","+params[:country].gsub(" ","+")
      google_url = URI.parse(URI.encode("http://maps.googleapis.com/maps/api/geocode/json?address="+google_address+"&sensor=false&language="+I18n.locale.to_s))
      google_req = Net::HTTP::Get.new(google_url.request_uri)
      google_res = Net::HTTP.start(google_url.host, google_url.port) {|http|
        http.request(google_req)
      }
      google_results = JSON.parse(google_res.body)["results"]
      if google_results.count == 1 && google_results[0]["geometry"]["location_type"] == "ROOFTOP"
        params[:address] = google_results[0]["address_components"].find_all{|item|
          item["types"] == ["route"]
        }[0]["long_name"]+" "+google_results[0]["address_components"].find_all{|item|
          item["types"] == ["street_number"]
        }[0]["long_name"]
        params[:zip] = google_results[0]["address_components"].find_all{|item|
          item["types"] == ["postal_code"]
        }[0]["long_name"]
        params[:city] = google_results[0]["address_components"].find_all{|item|
          item["types"] == ["locality", "political"]
        }[0]["long_name"]
        params[:country] = google_results[0]["address_components"].find_all{|item|
          item["types"] == ["country", "political"]
        }[0]["long_name"]

        session[:signup][:address] = params[:address]
        session[:signup][:zip] = params[:zip]
        session[:signup][:city] = params[:city]
        session[:signup][:country] = params[:country]
      
        render :json => {:status => "success", :redirect => url_for(:controller => "/signup", :action => "user")}
        return
      end
    end
    render :json => {:status => "invalid"}
  end
  
  def signup_user
    if !@user && session[:signup] && !params.values_at(:email, :password).include?(nil)
      @user = User.create(params.permit(:email, :password).merge({
        :password_confirmation => params[:password_confirmation],
        :last_login => DateTime.now,
        :product_referer => session[:signup][:product_referer]
      }))
      
      if @user.errors.count == 0 && !@user.blank?
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
            :country => session[:signup][:country]
          }),
          :default_language => Language.first,
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
        
        redirect_url = url_for(:controller => "/profile", :action => "index")
        if @user.product_referer == "d"
          redirect_url = url_for(:controller => "/dailycious", :action => "index")
          
          @user.send_mail("dailycious", t("email.signup_dailycious_subj"), t("email.signup_dailycious_msg",{:n=>@user.restaurant.name}))
        elsif @user.product_referer == "m"
          redirect_url = url_for(:controller => "/menumalist", :action => "index")
          
          @user.send_mail("menumalist", t("email.signup_menumalist_subj"), t("email.signup_menumalist_msg",{:n=>@user.restaurant.name,:e=>@user.email,:c=>@user.restaurant.download_code}))
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
        
        redirect_url = url_for(:controller => "/profile", :action => "index")
        if params[:product_referer] == "d"
          redirect_url = url_for(:controller => "/dailycious", :action => "index")
        elsif params[:product_referer] == "m"
          redirect_url = url_for(:controller => "/menumalist", :action => "index")
        end
        
        render :json => {:status => "success", :redirect => redirect_url}
        return
      end
    end
    render :json => {:status => "invalid"}
  end
  
end
