class App::DailyciousController < ApplicationController
  
  skip_before_filter  :verify_authenticity_token
  
  def signup
    if @device && !@user && !params.values_at(:name, :address, :zip, :city, :country, :email, :password).include?(nil)
      @user = User.new(params.permit(:email, :password).merge({
        :password_confirmation => params[:password],
        :last_login => DateTime.now,
        :product_referer => "d"
      }))
      download_code = SecureRandom.hex(3).upcase
      while Restaurant.find_by_download_code(download_code).present?
        download_code = SecureRandom.hex(3).upcase
      end
      restaurant = Restaurant.new(params.permit(:name, :logo_image).merge({
        :user => @user,
        :default_language => Language.first,
        :menuColorTemplate => MenuColorTemplate.first,
        :supportedFont => SupportedFont.first,
        :download_code => download_code,
        :background_type => "color"
      }))
      address = Location.validate_address(params.permit(:address, :zip, :city, :country))
      
      if @user.valid? && @user.errors.count == 0 && restaurant.valid? && restaurant.errors.count == 0 && address != nil
        @user.save
        restaurant.save
        restaurant.update_attributes({
          :location => Location.create(address),
          :menuColor => MenuColor.create(
            :background => "#000000",
            :bar_background => "#000000",
            :nav_text => "#ffffff",
            :nav_text_active => "#999999"
          ),
          :dailycious_plan => DailyciousPlan.create()
        })
        for i in 1..5
          DailyciousCredit.create(
            :restaurant => restaurant
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
        
        @user.restaurant.logo_image.set_crop_values_for_instance(params.permit(:logo_image, :logo_image_crop_w, :logo_image_crop_h, :logo_image_crop_x, :logo_image_crop_y))
        
        @user.send_mail(t("email.signup_dailycious_send"), t("email.signup_dailycious_subj"), t("email.signup_dailycious_msg",{:n=>@user.restaurant.name, :e=>@user.email}))

        session[:user_id] = @user.id
        
        render :partial => "login"
        return
      end
      render :json => {
        :token => @session.token,
        :status => "invalid",
        :errors => {
          :user => @user.errors.messages,
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
      @user = User.find_by_email(params[:email])
      
      if !@user.blank? && @user.authenticate(params[:password])
        
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
    elsif @device && @user
      
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
    if @device && @user && !params.values_at(:name, :address, :zip, :city, :country).include?(nil)
      address = Location.validate_address(params.permit(:address, :zip, :city, :country))
      
      @user.restaurant.attributes = params.permit(:name)
      if @user.restaurant.save && @user.restaurant.errors.count == 0 && address != nil
        @user.restaurant.update_attributes(params.permit(:name, :logo_image))
        @user.restaurant.location.update_attributes(address)
        @user.restaurant.logo_image.set_crop_values_for_instance(params.permit(:logo_image))
        
        render :partial => "login"
        return
      end
    end
    render :json => {
      :token => @session.token,
      :status => "invalid",
      :errors => {
        :restaurant => @user.restaurant.errors,
        :location => {
          :address => address == nil ? ["is invalid"] : []
        }
      }
    }
  end
  
  def adddailydish
    if @device && @user && !params.values_at(:display_date, :title, :price).include?(nil)
      todays_dailycious_credits = @user.restaurant.dailycious_credits.where(:usage_date => params[:display_date].to_date)
      todays_daily_dishes = @user.restaurant.daily_dishes.where(:display_date => params[:display_date].to_datetime)
      
      if todays_daily_dishes.count == 0 || (todays_daily_dishes.count > 0 && @user.restaurant.dailycious_credits.valid_credits.count > 0)
      params[:price] = params[:price] == "" ? "0.00" : ("%.2f" % params[:price].gsub(",", ".")).gsub(".", ",")
        new_daily_dish = DailyDish.create(params.permit(:display_date, :image, :title, :price).merge({
          :restaurant => @user.restaurant
        }))
        
        if new_daily_dish.errors.count == 0
          if todays_daily_dishes.count > todays_dailycious_credits.count+1
            @user.restaurant.dailycious_credits.valid_credits.first.update_attributes({
              :usage_date => params[:display_date]
            })
          end
          new_daily_dish.image.set_crop_values_for_instance(params.permit(:image))
          
          render :json => {
            :token => @session.token,
            :status => "success",
            :output => {
              :daily_dish_id => new_daily_dish.id
            }
          }
          return
        end

        render :json => {
          :token => @session.token,
          :status => "invalid",
          :errors => {
            :daily_dish => new_daily_dish.errors
          }
        }
        return
      end

      render :json => {
        :token => @session.token,
        :status => "invalid",
        :errors => {
          :daily_dish => {
            :credits => ["none"]
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
  
  def editdailydish
    if @device && @user && !params.values_at(:daily_dish_id, :title, :price).include?(nil) && DailyDish.exists?(params[:daily_dish_id]) && DailyDish.find(params[:daily_dish_id]).restaurant.user == @user
      daily_dish = DailyDish.find(params[:daily_dish_id])
      
      params[:price] = params[:price] == "" ? "0.00" : ("%.2f" % params[:price].gsub(",", ".")).gsub(".", ",")
      daily_dish.attributes = params.permit(:image, :title, :price)
      daily_dish.save
      if daily_dish.errors.count == 0
        daily_dish.image.set_crop_values_for_instance(params.permit(:image))
      
        render :json => {
          :token => @session.token,
          :status => "success"
        }
        return
      end

      render :json => {
        :token => @session.token,
        :status => "invalid",
        :errors => {
          :daily_dish => daily_dish.errors
        }
      }
      return
    end
    render :json => {
      :token => @session.token,
      :status => "invalid"
    }
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
  
  def useragreement
    if @device
      render :partial => "useragreement"
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
