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
        
        @user.restaurant.update_attributes(params.permit(:email, :website, :telephone).merge({
          :default_language => Language.find(params[:default_language])
        }))
        @user.restaurant.location.update_attributes(params.permit(:address, :zip, :city, :country).merge({
          :latitude => google_results[0]["geometry"]["location"]["lat"].to_f,
          :longitude => google_results[0]["geometry"]["location"]["lng"].to_f
        }))
        
        render :json => {:status => "success", :user => @user.restaurant}
        return
      end
      render :json => {:status => "invalid-2"}
      return
    end
    render :json => {:status => "invalid-1"}
  end
  
  def editdescription
    if @user && !params.values_at(:name, :description, :categories).include?(nil)
      @user.restaurant.attributes = params.permit(:logo_image, :restaurant_image, :name)
      
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
      
      if params[:logo_image]
        if @user.restaurant.logo_image_dimensions["original"][1] >= @user.restaurant.logo_image_dimensions["original"][0]
          @user.restaurant.logo_image_crop_w = @user.restaurant.logo_image_dimensions["original"].min
          @user.restaurant.logo_image_crop_h = @user.restaurant.logo_image_crop_w/(@user.restaurant.logo_image_dimensions["cropped_default_retina"][0].to_f/@user.restaurant.logo_image_dimensions["cropped_default_retina"][1].to_f)
        else
          @user.restaurant.logo_image_crop_h = @user.restaurant.logo_image_dimensions["original"].min
          @user.restaurant.logo_image_crop_w = (@user.restaurant.logo_image_dimensions["cropped_default_retina"][0].to_f/@user.restaurant.logo_image_dimensions["cropped_default_retina"][1].to_f)*@user.restaurant.logo_image_crop_h
        end
        @user.restaurant.logo_image_crop_x = (@user.restaurant.logo_image_dimensions["original"][0]-@user.restaurant.logo_image_crop_w).to_f/2
        @user.restaurant.logo_image_crop_y = (@user.restaurant.logo_image_dimensions["original"][1]-@user.restaurant.logo_image_crop_h).to_f/2
      elsif !params.values_at(:logo_image_crop_w, :logo_image_crop_h, :logo_image_crop_x, :logo_image_crop_y).include?(nil)
        if params[:logo_image_crop_w].to_i+params[:logo_image_crop_x].to_i > @user.restaurant.logo_image_dimensions["original"][0]
          params[:logo_image_crop_x] = @user.restaurant.logo_image_dimensions["original"][0]-params[:logo_image_crop_w].to_i
        end
        if params[:logo_image_crop_h].to_i+params[:logo_image_crop_y].to_i > @user.restaurant.logo_image_dimensions["original"][1]
          params[:logo_image_crop_y] = @user.restaurant.logo_image_dimensions["original"][1]-params[:logo_image_crop_h].to_i
        end
        
        @user.restaurant.attributes = params.permit(:logo_image_crop_w, :logo_image_crop_h, :logo_image_crop_x, :logo_image_crop_y)
        if @user.restaurant.logo_image_crop_w_changed? || @user.restaurant.logo_image_crop_h_changed? || @user.restaurant.restaurant.logo_image_crop_x_changed? || @user.restaurant.logo_image_crop_y_changed?
          @user.restaurant.save
          @user.restaurant.update_attributes({:logo_image_crop_processed => false})
          @user.restaurant.logo_image.reprocess!
          @user.restaurant.update_attributes({:logo_image_crop_processed => true})
        else
        end
      end
      
      if params[:restaurant_image]
        if @user.restaurant.restaurant_image_dimensions["original"][1] >= @user.restaurant.restaurant_image_dimensions["original"][0]
          @user.restaurant.restaurant_image_crop_w = @user.restaurant.restaurant_image_dimensions["original"].min
          @user.restaurant.restaurant_image_crop_h = @user.restaurant_image_crop_w/(@user.restaurant.restaurant_image_dimensions["cropped_default_retina"][0].to_f/@user.restaurant.restaurant_image_dimensions["cropped_default_retina"][1].to_f)
        else
          @user.restaurant.restaurant_image_crop_h = @user.restaurant.restaurant_image_dimensions["original"].min
          @user.restaurant.restaurant_image_crop_w = (@user.restaurant.restaurant_image_dimensions["cropped_default_retina"][0].to_f/@user.restaurant.restaurant_image_dimensions["cropped_default_retina"][1].to_f)*@user.restaurant.restaurant_image_crop_h
        end
        @user.restaurant.restaurant_image_crop_x = (@user.restaurant.restaurant_image_dimensions["original"][0]-@user.restaurant.restaurant_image_crop_w).to_f/2
        @user.restaurant.restaurant_image_crop_y = (@user.restaurant.restaurant_image_dimensions["original"][1]-@user.restaurant.restaurant_image_crop_h).to_f/2
      elsif !params.values_at(:restaurant_image_crop_w, :restaurant_image_crop_h, :restaurant_image_crop_x, :restaurant_image_crop_y).include?(nil)
        if params[:restaurant_image_crop_w].to_i+params[:restaurant_image_crop_x].to_i > @user.restaurant.restaurant_image_dimensions["original"][0]
          params[:restaurant_image_crop_x] = @user.restaurant.restaurant_image_dimensions["original"][0]-params[:restaurant_image_crop_w].to_i
        end
        if params[:restaurant_image_crop_h].to_i+params[:restaurant_image_crop_y].to_i > @user.restaurant.restaurant_image_dimensions["original"][1]
          params[:restaurant_image_crop_y] = @user.restaurant.restaurant_image_dimensions["original"][1]-params[:restaurant_image_crop_h].to_i
        end
        
        @user.restaurant.attributes = params.permit(:restaurant_image_crop_w, :restaurant_image_crop_h, :restaurant_image_crop_x, :restaurant_image_crop_y)
        if @user.restaurant.restaurant_image_crop_w_changed? || @user.restaurant.restaurant_image_crop_h_changed? || @user.restaurant.restaurant_image_crop_x_changed? || @user.restaurant.restaurant_image_crop_y_changed?
          @user.restaurant.save
          @user.restaurant.update_attributes({:restaurant_image_crop_processed => false})
          @user.restaurant.logo_image.reprocess!
          @user.restaurant.update_attributes({:restaurant_image_crop_processed => true})
        else
        end
      end
      
      @user.restaurant.save
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
