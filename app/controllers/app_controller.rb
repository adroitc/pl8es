require 'jsonify'

class AppController < ApplicationController
  
  respond_to :json
  
  def menumalist
    if User.find_by_download_code(params[:user_download_code])
      @user = app_user = User.find_by_download_code(params[:user_download_code])
      
      render :partial => "menumalist"
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
