class App::DailyciousController < ApplicationController
  
  skip_before_filter  :verify_authenticity_token
  
  def signup
    if @device && !@user && !params.values_at(:name, :address, :zip, :city, :country, :email, :password).include?(nil)
      @user = User.create(params.permit(:name, :email, :password))
      
      if @user.errors.count == 0 && !@user.blank?
        download_code = SecureRandom.hex(3).upcase
        while Restaurant.find_by_download_code(download_code).present?
          download_code = SecureRandom.hex(3).upcase
        end
        
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
          
          @user.update_attributes({
            :last_login => DateTime.now,
            :restaurant => Restaurant.create(params.permit(:name, :logo_image).merge({
              :location => Location.create(params.permit(:address, :zip, :city, :country)),
              :default_language => Language.first,
              :menuColorTemplate => MenuColorTemplate.first,
              :menuColor => MenuColor.create(),
              :supportedFont => SupportedFont.first,
              :download_code => download_code,
              :background_type => "color"
            }))
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
          end

          session[:user_id] = @user.id
        
          render :partial => "login"
          return
        end
      end
    end
    
    render :json => {:token => @session.token, :status => "invalid"}
  end
  
  def login
    if @device && !params.values_at(:email, :password).include?(nil)
      @user = User.find_by_email_and_password(params[:email], params[:password])
      if !@user.blank?
        
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
        
        render :partial => "login"
        return
      end
    elsif @device && @user
      
      render :partial => "login"
      return
    end
    render :json => {:token => @session.token, :status => "invalid"}
  end
  
  def profile
    if @device && @user && !params.values_at(:name, :address, :zip, :city, :country).include?(nil)
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
        
        @user.restaurant.update_attributes(params.permit(:name, :logo_image))
        @user.restaurant.location.update_attributes(params.permit(:address, :zip, :city, :country))
        
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
        end
        
        render :partial => "login"
        return
      end
    end
    render :json => {:token => @session.token, :status => "invalid"}
  end
  
  def adddailydish
    if @device && @user && !params.values_at(:display_date, :title, :price).include?(nil)
      new_daily_dish = DailyDish.create(params.permit(:display_date, :image, :title, :price).merge({
        :restaurant => @user.restaurant
      }))
      
      if params[:image]
        if new_daily_dish.image_dimensions["original"][1] >= new_daily_dish.image_dimensions["original"][0]
          new_daily_dish.image_crop_w = new_daily_dish.image_dimensions["original"].min
          new_daily_dish.image_crop_h = new_daily_dish.image_crop_w/(new_daily_dish.image_dimensions["cropped_default_retina"][0].to_f/new_daily_dish.image_dimensions["cropped_default_retina"][1].to_f)
        else
          new_daily_dish.image_crop_h = new_daily_dish.image_dimensions["original"].min
          new_daily_dish.image_crop_w = (new_daily_dish.image_dimensions["cropped_default_retina"][0].to_f/new_daily_dish.image_dimensions["cropped_default_retina"][1].to_f)*new_daily_dish.image_crop_h
        end
        new_daily_dish.image_crop_x = (new_daily_dish.image_dimensions["original"][0]-new_daily_dish.image_crop_w).to_f/2
        new_daily_dish.image_crop_y = (new_daily_dish.image_dimensions["original"][1]-new_daily_dish.image_crop_h).to_f/2
        
        new_daily_dish.save
      end
      
      render :json => {:token => @session.token, :status => "success"}
      return
    end
    render :json => {:token => @session.token, :status => "invalid"}
  end
  
  def editdailydish
    if @device && @user && !params.values_at(:daily_dish_id, :title, :price).include?(nil) && DailyDish.exists?(params[:daily_dish_id]) && DailyDish.find(params[:daily_dish_id]).restaurant.user == @user
      daily_dish = DailyDish.find(params[:daily_dish_id])
      
      daily_dish.update_attributes(params.permit(:image, :title, :price))
      
      if params[:image]
        if daily_dish.image_dimensions["original"][1] >= daily_dish.image_dimensions["original"][0]
          daily_dish.image_crop_w = daily_dish.image_dimensions["original"].min
          daily_dish.image_crop_h = daily_dish.image_crop_w/(daily_dish.image_dimensions["cropped_default_retina"][0].to_f/daily_dish.image_dimensions["cropped_default_retina"][1].to_f)
        else
          daily_dish.image_crop_h = daily_dish.image_dimensions["original"].min
          daily_dish.image_crop_w = (daily_dish.image_dimensions["cropped_default_retina"][0].to_f/daily_dish.image_dimensions["cropped_default_retina"][1].to_f)*daily_dish.image_crop_h
        end
        daily_dish.image_crop_x = (daily_dish.image_dimensions["original"][0]-daily_dish.image_crop_w).to_f/2
        daily_dish.image_crop_y = (daily_dish.image_dimensions["original"][1]-daily_dish.image_crop_h).to_f/2
      end
      daily_dish.save
      
      render :json => {:token => @session.token, :status => "success"}
      return
    end
    render :json => {:token => @session.token, :status => "invalid"}
  end
  
  def sortdailydish
    if @device && @user && !params.values_at(:daily_dish_ids).include?(nil)
      params[:daily_dish_ids].each do |daily_dish_id|
        if DailyDish.exists?(daily_dish_id[0].to_i) && DailyDish.find(daily_dish_id[0].to_i).restaurant.user == @user
          DailyDish.find(daily_dish_id[0].to_i).update_attributes({
            :position => daily_dish_id[1].to_i
          })
        end
      end
      
      render :json => {:token => @session.token, :status => "success"}
      return
    end
    render :json => {:token => @session.token, :status => "invalid"}
  end
  
  def week
    if @device && @user && !params.values_at(:q).include?(nil)
      @add_weeks = params[:q].to_i
      render :partial => "week"
      return
    end
    render :json => {:token => @session.token, :status => "invalid"}
  end
  
  def defaults
    if @device
      render :partial => "defaults"
      return
    end
    render :json => {:token => @session.token, :status => "invalid"}
  end
  
  def favorites
    if @device && !params.values_at(:q).include?(nil)
      restaurants = Restaurant.where([
        "id IN (?) AND id IN (?)",
        params[:q].split(",").drop(2),
        DailyDish.find(
          :all,
          :select => "restaurant_id",
          :conditions => [
            "display_date = (?)",
            Date.today.to_datetime
          ]
        ).map{|d| d.restaurant_id}
      ])
      @device.restaurants = restaurants
      @req_locations = restaurants.map{|r| r.location}.sort_by do |e|
        distance = e.distance_to([
          params[:q].split(",")[0].to_f,
          params[:q].split(",")[1].to_f
        ])
        e.distance = distance
        distance
      end
      #.order("distance")
      
      render :partial => "map"
      return
    end
    render :json => {:token => @session.token, :status => "invalid"}
  end
  
  def map
    if @device && !params.values_at(:q).include?(nil)
      #restaurants = Restaurant.where([
      #  "id IN (?)",
      #  DailyDish.find(
      #    :all,
      #    :select => "restaurant_id",
      #    :conditions => [
      #      "display_date = (?)",
      #      Date.today.to_datetime
      #    ]
      #  ).map{|d| d.restaurant_id}
      #])
      locations = Location.where([
        "restaurant_id IN (?)",
        DailyDish.find(
          :all,
          :select => "restaurant_id",
          :conditions => [
            "display_date = (?)",
            Date.today.to_datetime
          ]
        ).map{|d| d.restaurant_id}
      ])
      @req_locations = locations.in_bounds(#restaurants.map{|r| r.location}.in_bounds(
        [
          [
            params[:q].split(",")[2].to_f,
            params[:q].split(",")[3].to_f
          ],
          [
            params[:q].split(",")[4].to_f,
            params[:q].split(",")[5].to_f
          ]
        ],
        :origin => [
          params[:q].split(",")[0].to_f,
          params[:q].split(",")[1].to_f
        ]
      ).sort_by do |e|
        distance = e.distance_to([
          params[:q].split(",")[0].to_f,
          params[:q].split(",")[1].to_f
        ])
        e.distance = distance
        distance
      end
      #.order("distance")
      
      render :partial => "map"
      return
    end
    render :json => {:token => @session.token, :status => "invalid"}
  end
  
  def suggestions
    if @device && !params.values_at(:q).include?(nil) && params[:q].length > 0
      query = "%#{params[:q].gsub("+"," ").downcase}%"
      
      suggestions = DailyDish.unscoped.find(
        :all,
        :select => ActiveRecord::Base.send(:sanitize_sql_array,[
          "CASE WHEN LOWER(restaurants.name) LIKE (?) THEN restaurants.name WHEN category_translations.title IS NOT NULL THEN category_translations.title ELSE daily_dishes.title END AS suggestion",
          query
        ]),
        :joins => [
          "INNER JOIN restaurants ON restaurants.id = daily_dishes.restaurant_id",
          "LEFT JOIN categories_restaurants ON categories_restaurants.restaurant_id = daily_dishes.restaurant_id",
          ActiveRecord::Base.send(:sanitize_sql_array,[
            "LEFT JOIN category_translations ON category_translations.category_id = categories_restaurants.category_id AND LOWER(category_translations.title) LIKE (?)",
            query
          ])
        ],
        :conditions => [
          "display_date = (?) AND (LOWER(daily_dishes.title) LIKE (?) OR daily_dishes.restaurant_id IN (?))",
          Date.today.to_datetime,
          "#{query}",
          Restaurant.find(
            :all,
            :select => "id",
            :conditions => ["LOWER(name) LIKE (?)",
              "#{query}"
            ]
          ).map{|u| u.id}.concat(
            ActiveRecord::Base.connection.execute(ActiveRecord::Base.send(:sanitize_sql_array,[
              "SELECT restaurant_id FROM categories_restaurants, category_translations WHERE categories_restaurants.category_id = category_translations.category_id AND LOWER(category_translations.title) LIKE (?)",
              query
            ])).map{|u| u["restaurant_id"]}
          )
        ],
        :group => "suggestion",
        :order => "suggestion"
      ).map{|u| u.suggestion}
      
      render :json => {:token => @session.token, :suggestions => suggestions}
      return
    end
    render :json => {:token => @session.token, :status => "invalid"}
  end
  
  def search
    if @device && !params.values_at(:q).include?(nil) && params[:q].length > 0
      query = "%#{params[:q].gsub("+"," ").downcase}%"
      
      @req_locations = Location.where(
        ["restaurant_id IN (?)",
          DailyDish.unscoped.find(
            :all,
            :select => "daily_dishes.restaurant_id",
            :joins => [
              "INNER JOIN restaurants ON restaurants.id = daily_dishes.restaurant_id",
              "LEFT JOIN categories_restaurants ON categories_restaurants.restaurant_id = daily_dishes.restaurant_id",
              ActiveRecord::Base.send(:sanitize_sql_array,[
                "LEFT JOIN category_translations ON category_translations.category_id = categories_restaurants.category_id AND LOWER(category_translations.title) LIKE (?)",
                query
              ])
            ],
            :conditions => [
              "display_date = (?) AND (LOWER(daily_dishes.title) LIKE (?) OR daily_dishes.restaurant_id IN (?))",
              Date.today.to_datetime,
              "#{query}",
              Restaurant.find(
                :all,
                :select => "id",
                :conditions => ["LOWER(name) LIKE (?)",
                  "#{query}"
                ]
              ).map{|u| u.id}.concat(
                ActiveRecord::Base.connection.execute(ActiveRecord::Base.send(:sanitize_sql_array,[
                  "SELECT restaurant_id FROM categories_restaurants, category_translations WHERE categories_restaurants.category_id = category_translations.category_id AND LOWER(category_translations.title) LIKE (?)",
                  query
                ])).map{|u| u["restaurant_id"]}
              )
            ],
            :group => "daily_dishes.restaurant_id"
          ).map{|u| u.restaurant_id}
        ]
      ).sort_by do |e|
        distance = e.distance_to([
          params[:q].split(",")[0].to_f,
          params[:q].split(",")[1].to_f
        ])
        e.distance = distance
        distance
      end
      
      render :partial => "map"
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
