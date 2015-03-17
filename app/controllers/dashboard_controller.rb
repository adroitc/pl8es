class DashboardController < ApplicationController
  
  def index
    if !current_user
      redirect_to login_index_path
    end
  end
  
end
