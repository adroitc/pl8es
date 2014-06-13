class App::DailyciousController < ApplicationController
  
  def defaults
  end
  
  def map
    if !params.values_at(:q).include?(nil)
      @req_locations = Location.where(["user_id IN (?)", DailyDish.find(:all, :select => "user_id", :conditions => ["display_date = (?)", Date.today.to_datetime]).map{|d| d.user_id}]).within(
      10,
      :origin => [
        params[:q].split(",")[0].to_f,
        params[:q].split(",")[1].to_f
      ]
      ).order("distance")
      
      render :partial => "map"
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def user
    if !params.values_at(:user_id).include?(nil) && Location.exists?(params[:user_id])
      @req_location = Location.find(params[:user_id])
      
      render :partial => "user"
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
