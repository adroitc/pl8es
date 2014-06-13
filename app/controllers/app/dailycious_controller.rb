class App::DailyciousController < ApplicationController
  
  def defaults
  end
  
  def map
    @req_locations = Location.where(["user_id IN (?)", DailyDish.find(:all, :select => "user_id", :conditions => ["display_date = (?)", Date.today.to_datetime]).map{|d| d.user_id}]).within(
    10,
    :origin => [
      params[:lat_long].split(",")[0].to_f,
      params[:lat_long].split(",")[1].to_f
    ]
    ).order("distance")
    
    render :partial => "map"
    return
  end
  
  def user
    if Location.exists?(params[:user_id])
      @req_location = Location.find(params[:user_id])
      
      render :partial => "user"
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
