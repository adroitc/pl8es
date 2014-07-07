class DailyciousController < ApplicationController
  
  def index
    if params[:add_weeks] == "0"
      redirect_to :controller => "dailycious", :action => "index"
    elsif !@user
      redirect_to :controller => "login", :action => "index"
    end
  end
  
end
