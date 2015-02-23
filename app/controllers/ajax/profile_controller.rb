class Ajax::ProfileController < ApplicationController
  
  def editsettings
    if @user && !params.values_at(:default_language, :billing_contact, :address, :zip, :city, :country, :latitude, :longitude, :email, :password_old, :password_new).include?(nil) && Language.exists?(params[:default_language])

      @user.update_attributes(params.permit(:email))
      @user.restaurant.update_attributes(params.permit(:billing_contact, :email, :website, :telephone).merge({
        :default_language => Language.find(params[:default_language])
      }))
      
      if @user.authenticate(params[:password_old])
        @user.update_attributes({
          :password => params[:password_new],
          :password_confirmation => params[:password_new]
        })
      end
      
      @user.restaurant.location.update_attributes(params.permit(:address, :zip, :city, :country, :latitude, :longitude))
      
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
      #  @user.restaurant.location.update_attributes(params.permit(:address, :zip, :city, :country).merge({
      #    :latitude => google_results[0]["geometry"]["location"]["lat"].to_f,
      #    :longitude => google_results[0]["geometry"]["location"]["lng"].to_f
      #  }))
      #  
      #  render :json => {:status => "success"}
      #  return
      #end
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def editdescription
    if @user && !params.values_at(:name, :description).include?(nil)
      @user.restaurant.update(params.permit(:logo_image, :restaurant_image, :name))
      
      languages = Language.find_all_by_locale(params[:description].keys)
      
      current_locale = I18n.locale
      languages.each do |language|
        I18n.locale = language.locale
        @user.restaurant.description = params[:description][language.locale]
      end
      I18n.locale = current_locale
      
      @user.restaurant.save
      
      @user.restaurant.update(params.permit(:logo_image))
      @user.restaurant.logo_image.set_crop_values_for_instance(params.permit(:logo_image, :logo_image_crop_w, :logo_image_crop_h, :logo_image_crop_x, :logo_image_crop_y))
      
      @user.restaurant.update(params.permit(:restaurant_image))
      @user.restaurant.restaurant_image.set_crop_values_for_instance(params.permit(:restaurant_image, :restaurant_image_crop_w, :restaurant_image_crop_h, :restaurant_image_crop_x, :restaurant_image_crop_y))
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
