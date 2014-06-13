class App::DailyciousController < ApplicationController
  
  def defaults
    render :partial => "defaults"
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
  
  def search
    if !params.values_at(:q).include?(nil) && params[:q].length > 2
      @req_locations = Location.where(
        ["user_id IN (?)",
          DailyDish.find(
            :all,
            :select => "user_id",
            :conditions => ["display_date = (?) AND (title LIKE (?))",
              Date.today.to_datetime,
              "%#{params[:q]}%"
            ]
          ).map{|d| d.user_id}.concat(
            User.find(
              :all,
              :select => "id",
              :conditions => ["name LIKE (?)",
                "%#{params[:q]}%"
              ]
            ).map{|u| u.id}
          )
        ]
      )
      
      user_ids = DailyDish.find(
            :all,
            :select => "user_id",
            :conditions => ["display_date = (?) AND (title LIKE (?))",
              Date.today.to_datetime,
              "%#{params[:q]}%"
            ]
          ).map{|d| d.user_id}.concat(
            User.find(
              :all,
              :select => "id",
              :conditions => ["name LIKE (?)",
                "%#{params[:q]}%"
              ]
            ).map{|u| u.id}
          )
      #.order("distance")
      
      render :json => user_ids
      return
      
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
