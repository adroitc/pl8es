class DailyciousController < ApplicationController
  
  def index
    if current_user && params[:add_weeks] == "0"
      redirect_to offers_path, :add_weeks => nil
    elsif !current_user
      redirect_to new_user_session_path
    end
  end
  
end
