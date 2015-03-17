class DailyciousController < ApplicationController
  
  def index
    if current_user && params[:add_weeks] == "0"
      redirect_to dailycious_path, :add_weeks => nil
    elsif !current_user
      redirect_to login_index_path
    end
  end
  
end
