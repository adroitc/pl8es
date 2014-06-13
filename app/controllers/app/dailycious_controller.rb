class App::DailyciousController < ApplicationController
  
  def defaults
  end
  
  def map
    if !params.values_at(:q).include?(nil)
      @req_locations = Location.where(["user_id IN (?)", DailyDish.find(:all, :select => "user_id", :conditions => ["display_date = (?)", Date.today.to_datetime]).map{|d| d.user_id}])
      if @req_locations.count > 0
        @req_locations = @req_locations.within(
        10,
        :origin => [
          params[:q].split(",")[0].to_f,
          params[:q].split(",")[1].to_f
        ]
        ).order("distance")
      end
      
      render :partial => "map"
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def user
    if Location.exists?(params[:q])
      @req_location = Location.find(params[:q])
      
      render :partial => "user"
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
