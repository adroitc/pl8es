class App::DailyciousController < ApplicationController
  
  def defaults
    render :partial => "defaults"
  end
  
  def favorites
  end
  
  def map
    if !params.values_at(:q).include?(nil)
      @req_locations = Location.where(["user_id IN (?)", DailyDish.find(:all, :select => "user_id", :conditions => ["display_date = (?)", Date.today.to_datetime]).map{|d| d.user_id}]).in_bounds(
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
      suggestions = DailyDish.find(
        :all,
        :select => "title",
        :conditions => ["display_date = (?) AND LOWER(title) LIKE (?)",
          Date.today.to_datetime,
          "%#{params[:q].gsub("+"," ").downcase}%"
        ]
      ).map{|d| d.title}.concat(
        User.find(
          :all,
          :select => "name",
          :conditions => ["LOWER(name) LIKE (?)",
            "%#{params[:q].gsub("+"," ").downcase}%"
          ]
        ).map{|u| u.name}
      ).concat(
        ActiveRecord::Base.connection.execute("SELECT title FROM categories_users, category_translations WHERE categories_users.category_id = category_translations.category_id AND LOWER(category_translations.title) LIKE ('%#{params[:q].gsub("+"," ").downcase}%')").map{|u| u["title"]}
      ).uniq
      #suggestions = DailyDish.unscoped.find(
      #  :all,
      #  :select => "CASE WHEN LOWER(users.name) NOT LIKE '%#{params[:q].gsub("+"," ").downcase}%' THEN users.name ELSE daily_dishes.title END AS suggestion",
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
      #  :group => "suggestion",
      #  :order => "suggestion"
      #).map{|u| u.suggestion}
      
      render :json => {:suggestions => suggestions}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def search
    if !params.values_at(:q).include?(nil)
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
          DailyDish.find(
            :all,
            :select => "user_id",
            :conditions => ["display_date = (?) AND LOWER(title) LIKE (?)",
              Date.today.to_datetime,
              "%#{params[:q].gsub("+"," ").downcase}%"
            ]
          ).map{|d| d.user_id}.concat(
            User.find(
              :all,
              :select => "id",
              :conditions => ["LOWER(name) LIKE (?)",
                "%#{params[:q].gsub("+"," ").downcase}%"
              ]
            ).map{|u| u.id}
          ).concat(
            ActiveRecord::Base.connection.execute("SELECT user_id FROM categories_users, category_translations WHERE categories_users.category_id = category_translations.category_id AND LOWER(category_translations.title) LIKE ('%#{params[:q].gsub("+"," ").downcase}%')").map{|u| u["user_id"]}
          ).uniq
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
