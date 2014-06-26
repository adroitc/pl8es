class App::DailyciousController < ApplicationController
  
  skip_before_filter  :verify_authenticity_token
  
  def login
    if !params.values_at(:email, :password).include?(nil)
      @user = User.find_by_email_and_password(params[:email], params[:password])
      
      if !@user.blank?
        session[:user_id] = @user.id
        
        render :partial => "login"
        return
      end
    elsif @user
      render :partial => "login"
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def adddailydish
    if @user && !params.values_at(:display_date, :title, :price).include?(nil)
      new_daily_dish = DailyDish.create(params.permit(:display_date, :image, :title, :price).merge({user: @user}))
      
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
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def week
    if @user && !params.values_at(:q).include?(nil)
      @add_weeks = params[:q].to_i
      render :partial => "week"
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def defaults
    render :partial => "defaults"
  end
  
  def favorites
    if !params.values_at(:q).include?(nil)
      @req_locations = Location.where([
        "id IN (?) AND user_id IN (?)",
        params[:q].split(",").drop(2),
        DailyDish.find(
          :all,
          :select => "user_id",
          :conditions => [
            "display_date = (?)",
            Date.today.to_datetime
          ]
        ).map{|d| d.user_id}
      ]).sort_by do |e|
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
    render :json => {:status => "invalid"}
  end
  
  def map
    if !params.values_at(:q).include?(nil)
      @req_locations = Location.where([
        "user_id IN (?)",
        DailyDish.find(
          :all,
          :select => "user_id",
          :conditions => [
            "display_date = (?)",
            Date.today.to_datetime
          ]
        ).map{|d| d.user_id}
      ]).in_bounds(
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
    render :json => {:status => "invalid"}
  end
  
  def suggestions
    if !params.values_at(:q).include?(nil)
      #suggestions = DailyDish.find(
      #  :all,
      #  :select => "title",
      #  :conditions => ["display_date = (?) AND LOWER(title) LIKE (?)",
      #    Date.today.to_datetime,
      #    "%#{params[:q].gsub("+"," ").downcase}%"
      #  ]
      #).map{|d| d.title}.concat(
      #  User.find(
      #    :all,
      #    :select => "name",
      #    :conditions => ["LOWER(name) LIKE (?)",
      #      "%#{params[:q].gsub("+"," ").downcase}%"
      #    ]
      #  ).map{|u| u.name}
      #).concat(
      #  ActiveRecord::Base.connection.execute("SELECT title FROM categories_users, category_translations WHERE categories_users.category_id = category_translations.category_id AND LOWER(category_translations.title) LIKE ('%#{params[:q].gsub("+"," ").downcase}%')").map{|u| u["title"]}
      #).uniq

      query = "%#{params[:q].gsub("+"," ").downcase}%"
      
      suggestions = DailyDish.unscoped.find(
        :all,
        :select => ActiveRecord::Base.send(:sanitize_sql_array,[
          "CASE WHEN LOWER(users.name) LIKE (?) THEN users.name WHEN category_translations.title IS NOT NULL THEN category_translations.title ELSE daily_dishes.title END AS suggestion",
          query
        ]),
        :joins => [
          "INNER JOIN users ON users.id = daily_dishes.user_id",
          "LEFT JOIN categories_users ON categories_users.user_id = daily_dishes.user_id",
          ActiveRecord::Base.send(:sanitize_sql_array,[
            "LEFT JOIN category_translations ON category_translations.category_id = categories_users.category_id AND LOWER(category_translations.title) LIKE (?)",
            query
          ])
        ],
        :conditions => [
          "display_date = (?) AND (LOWER(daily_dishes.title) LIKE (?) OR daily_dishes.user_id IN (?))",
          Date.today.to_datetime,
          "#{query}",
          User.find(
            :all,
            :select => "id",
            :conditions => ["LOWER(name) LIKE (?)",
              "#{query}"
            ]
          ).map{|u| u.id}.concat(
            ActiveRecord::Base.connection.execute(ActiveRecord::Base.send(:sanitize_sql_array,[
              "SELECT user_id FROM categories_users, category_translations WHERE categories_users.category_id = category_translations.category_id AND LOWER(category_translations.title) LIKE (?)",
              query
            ])).map{|u| u["user_id"]}
          )
        ],
        :group => "suggestion",
        :order => "suggestion"
      ).map{|u| u.suggestion}
      
      render :json => {:suggestions => suggestions}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def search
    if !params.values_at(:q).include?(nil)
      query = "%#{params[:q].gsub("+"," ").downcase}%"
      
      @req_locations = Location.where(
        ["user_id IN (?)",
          #DailyDish.find(
          #  :all,
          #  :select => "title",
          #  :conditions => ["display_date = (?) AND LOWER(title) LIKE (?)",
          #    Date.today.to_datetime,
          #    "%#{params[:q].gsub("+"," ").downcase}%"
          #  ]
          #).map{|d| d.user_id}.concat(
          #  User.find(
          #    :all,
          #    :select => "name",
          #    :conditions => ["LOWER(name) LIKE (?)",
          #      "%#{params[:q].gsub("+"," ").downcase}%"
          #    ]
          #  ).map{|u| u.id}
          #)
          
          #DailyDish.unscoped.find(
          #  :all,
          #  :select => "daily_dishes.user_id",
          #  :joins => [
          #    "INNER JOIN users ON users.id = daily_dishes.user_id",
          #    "INNER JOIN categories_users ON categories_users.user_id = daily_dishes.user_id",
          #    "LEFT JOIN category_translations ON category_translations.category_id = categories_users.category_id AND LOWER(category_translations.title) LIKE ('%#{params[:q].gsub("+"," ").downcase}%')"
          #  ],
          #  :conditions => [
          #    "display_date = (?) AND (LOWER(daily_dishes.title) LIKE (?) OR daily_dishes.user_id IN (?))",
          #    Date.today.to_datetime,
          #    "%#{params[:q].gsub("+"," ").downcase}%",
          #    User.find(
          #      :all,
          #      :select => "id",
          #      :conditions => ["LOWER(name) LIKE (?)",
          #        "%#{params[:q].gsub("+"," ").downcase}%"
          #      ]
          #    ).map{|u| u.id}.concat(
          #      ActiveRecord::Base.connection.execute("SELECT user_id FROM categories_users, category_translations WHERE categories_users.category_id = category_translations.category_id AND LOWER(category_translations.title) LIKE '%italienisch%'").map{|u| u["user_id"]}
          #    )
          #  ],
          #  :group => "daily_dishes.user_id"
          #).map{|u| u.user_id}
          
          DailyDish.unscoped.find(
            :all,
            :select => "daily_dishes.user_id",
            :joins => [
              "INNER JOIN users ON users.id = daily_dishes.user_id",
              "LEFT JOIN categories_users ON categories_users.user_id = daily_dishes.user_id",
              ActiveRecord::Base.send(:sanitize_sql_array,[
                "LEFT JOIN category_translations ON category_translations.category_id = categories_users.category_id AND LOWER(category_translations.title) LIKE (?)",
                query
              ])
            ],
            :conditions => [
              "display_date = (?) AND (LOWER(daily_dishes.title) LIKE (?) OR daily_dishes.user_id IN (?))",
              Date.today.to_datetime,
              "#{query}",
              User.find(
                :all,
                :select => "id",
                :conditions => ["LOWER(name) LIKE (?)",
                  "#{query}"
                ]
              ).map{|u| u.id}.concat(
                ActiveRecord::Base.connection.execute(ActiveRecord::Base.send(:sanitize_sql_array,[
                  "SELECT user_id FROM categories_users, category_translations WHERE categories_users.category_id = category_translations.category_id AND LOWER(category_translations.title) LIKE (?)",
                  query
                ])).map{|u| u["user_id"]}
              )
            ],
            :group => "daily_dishes.user_id"
          ).map{|u| u.user_id}
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
    render :json => {:status => "invalid"}
  end
  
  def user
    if !params.values_at(:q).include?(nil) && Location.exists?(params[:q])
      @req_location = Location.find(params[:q])
      
      render :partial => "user"
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
