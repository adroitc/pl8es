class Ajax::ProfileController < ApplicationController
  
  def editsettings
    if @user && !params.values_at(:default_language, :email, :address, :zip, :city, :country).include?(nil) && Language.exists?(params[:default_language])
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
        
        @user.restaurant.update(params.permit(:email, :website, :telephone).merge({
          :default_language => Language.find(params[:default_language])
        }))
        @user.restaurant.save
        @user.restaurant.location.update(params.permit(:address, :zip, :city, :country).merge({
          :latitude => google_results[0]["geometry"]["location"]["lat"].to_f,
          :longitude => google_results[0]["geometry"]["location"]["lng"].to_f
        }))
        @user.restaurant.location.save
        
        render :json => {:status => "success"}
        return
      end
      render :json => {:status => "invalid-2"}
      return
    end
    render :json => {:status => "invalid-1"}
  end
  
  def editdescription
    if @user && !params.values_at(:name, :description, :categories).include?(nil)
      @user.restaurant.update_attributes(params.permit(:logo_image, :restaurant_image, :name))
      
      languages = Language.find_all_by_locale(params[:description].keys)
      
      current_locale = I18n.locale
      languages.each do |language|
        I18n.locale = language.locale
        @user.restaurant.description = params[:description][language.locale]
      end
      I18n.locale = current_locale
      
      @user.restaurant.categories = []
      params[:categories].each_with_index do |category, i|
        break if i >= 2;
        if Category.exists?(category[1].to_i)
          @user.restaurant.categories.push(Category.find(category[1].to_i))
        end
      end
      
      @user.restaurant.save
      
      @user.restaurant.update_attributes(params.permit(:logo_image))
      @user.restaurant.logo_image.image.set_crop_values_for_instance(params.permit(:logo_image, :logo_image_crop_w, :logo_image_crop_h, :logo_image_crop_x, :logo_image_crop_y))
      
      @user.restaurant.update_attributes(params.permit(:restaurant_image))
      @user.restaurant.restaurant_image.image.set_crop_values_for_instance(params.permit(:restaurant_image, :restaurant_image_crop_w, :restaurant_image_crop_h, :restaurant_image_crop_x, :restaurant_image_crop_y))
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
