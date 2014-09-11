class DailyciousController < ApplicationController
  
  def index
    if @user && params[:add_weeks] == "0"
      redirect_to :controller => "dailycious", :action => "index", :add_weeks => nil
    elsif !@user
      redirect_to :controller => "login", :action => "index"
    end
  end
  
end
