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
  
  def hello

    if @device

			@token = @session.token
			@tags = Tag.all

			render 'hello.json.jbuilder'

			return

		end

    render :json => {
				:token => @session.token,
				:status => 'invalid'
		}

	end

  def map

		if @device && request.headers['Token'] && !params.values_at(:ne, :sw, :origin).include?(nil)


			@locations = Location.joins(:restaurant)
			.merge(Restaurant.joins(:offers).merge(Offer.in_range([Date.today]))).distinct
			.in_bounds([params[:sw].split(','), params[:ne].split(',')], :origin => params[:origin].split(','))
			.sort_by do |e|
				e.distance = e.distance_to(params[:origin].split(','))
			end

			render 'restaurants.json.jbuilder'
			return

		end

		render :json => {
				:token => @session.token,
				:status => 'invalid'
		}

	end

	def search

		if @device && request.headers['Token'] && !params.values_at(:term, :page, :origin).include?(nil)

			@locations = Location.joins(:restaurant)
			.merge(Restaurant.joins(:offers).merge(Offer.in_range([Date.today]))).distinct
			.sort_by do |e|
				e.distance = e.distance_to(params[:origin].split(','))
			end

			render 'restaurants.json.jbuilder'
			return

		end

		render :json => {
				:token => @session.token,
				:status => 'invalid'
		}

	end
  
  def useragreement
    if @device
      render :partial => "useragreement"
      return
    end
    render :json => {:token => @session.token, :status => "invalid"}
  end
  
#   def favorites
#     if @device && !params.values_at(:q).include?(nil)
# 
# 			restaurants = Restaurant.where(
# 					:id => DailyDish.select(:restaurant_id).where(:display_date => Date.today.to_datetime)
# 			).where(
# 					:id => params[:q].split(",").drop(2)
# 			)
# 
#       @device.restaurants = restaurants
#       @req_locations = restaurants.map{|r| r.location}.sort_by do |e|
#         distance = e.distance_to([
#           params[:q].split(",")[0].to_f,
#           params[:q].split(",")[1].to_f
#         ])
#         e.distance = distance
#         distance
#       end
#       #.order("distance")
#       
#       render :partial => "map"
#       return
#     end
#     render :json => {:token => @session.token, :status => "invalid"}
#   end
#   

#   
#   def suggestions
#     if @device && !params.values_at(:q).include?(nil) && params[:q].length > 0
#       query = "%#{params[:q].gsub("+"," ").downcase}%"
#       
#       suggestions = DailyDish.unscoped.find(
#         :all,
#         :select => ActiveRecord::Base.send(:sanitize_sql_array,[
#           "CASE WHEN LOWER(restaurants.name) LIKE (?) THEN restaurants.name WHEN tag_translations.title IS NOT NULL THEN tag_translations.title ELSE daily_dishes.title END AS suggestion",
#           query
#         ]),
#         :joins => [
#           "INNER JOIN restaurants ON restaurants.id = daily_dishes.restaurant_id",
#           "LEFT JOIN tags_restaurants ON tags_restaurants.restaurant_id = daily_dishes.restaurant_id",
#           ActiveRecord::Base.send(:sanitize_sql_array,[
#             "LEFT JOIN tag_translations ON tag_translations.tag_id = tags_restaurants.tag_id AND LOWER(tag_translations.title) LIKE (?)",
#             query
#           ])
#         ],
#         :conditions => [
#           "display_date = (?) AND (LOWER(daily_dishes.title) LIKE (?) OR daily_dishes.restaurant_id IN (?))",
#           Date.today.to_datetime,
#           "#{query}",
#           Restaurant.find(
#             :all,
#             :select => "id",
#             :conditions => ["LOWER(name) LIKE (?)",
#               "#{query}"
#             ]
#           ).map{|u| u.id}.concat(
#             ActiveRecord::Base.connection.execute(ActiveRecord::Base.send(:sanitize_sql_array,[
#               "SELECT restaurant_id FROM tags_restaurants, tag_translations WHERE tags_restaurants.tag_id = tag_translations.tag_id AND LOWER(tag_translations.title) LIKE (?)",
#               query
#             ])).map{|u| u["restaurant_id"]}
#           )
#         ],
#         :group => "suggestion",
#         :order => "suggestion"
#       ).map{|u| u.suggestion}
#       
#       render :json => {:token => @session.token, :suggestions => suggestions}
#       return
#     end
#     render :json => {:token => @session.token, :status => "invalid"}
#   end
#   
#   def search
#     if @device && !params.values_at(:q).include?(nil) && params[:q].length > 0
#       query = "%#{params[:q].gsub("+"," ").downcase}%"
#       
#       @req_locations = Location.where(
#         ["restaurant_id IN (?)",
#           DailyDish.unscoped.find(
#             :all,
#             :select => "daily_dishes.restaurant_id",
#             :joins => [
#               "INNER JOIN restaurants ON restaurants.id = daily_dishes.restaurant_id",
#               "LEFT JOIN tags_restaurants ON tags_restaurants.restaurant_id = daily_dishes.restaurant_id",
#               ActiveRecord::Base.send(:sanitize_sql_array,[
#                 "LEFT JOIN tag_translations ON tag_translations.tag_id = tags_restaurants.tag_id AND LOWER(tag_translations.title) LIKE (?)",
#                 query
#               ])
#             ],
#             :conditions => [
#               "display_date = (?) AND (LOWER(daily_dishes.title) LIKE (?) OR daily_dishes.restaurant_id IN (?))",
#               Date.today.to_datetime,
#               "#{query}",
#               Restaurant.find(
#                 :all,
#                 :select => "id",
#                 :conditions => ["LOWER(name) LIKE (?)",
#                   "#{query}"
#                 ]
#               ).map{|u| u.id}.concat(
#                 ActiveRecord::Base.connection.execute(ActiveRecord::Base.send(:sanitize_sql_array,[
#                   "SELECT restaurant_id FROM tags_restaurants, tag_translations WHERE tags_restaurants.tag_id = tag_translations.tag_id AND LOWER(tag_translations.title) LIKE (?)",
#                   query
#                 ])).map{|u| u["restaurant_id"]}
#               )
#             ],
#             :group => "daily_dishes.restaurant_id"
#           ).map{|u| u.restaurant_id}
#         ]
#       ).sort_by do |e|
#         distance = e.distance_to([
#           params[:q].split(",")[0].to_f,
#           params[:q].split(",")[1].to_f
#         ])
#         e.distance = distance
#         distance
#       end
#       
#       render :partial => "map"
#       return
#     end
#     render :json => {:token => @session.token, :status => "invalid"}
#   end
  
  def user
    if @device && !params.values_at(:q).include?(nil) && Restaurant.exists?(params[:q])
      @req_location = Restaurant.find(params[:q]).location
      
      render :partial => "user"
      return
    end
    render :json => {:token => @session.token, :status => "invalid"}
  end
  
end
