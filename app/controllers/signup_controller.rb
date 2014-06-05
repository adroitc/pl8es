class SignupController < ApplicationController
  
  def index
    if @user
      redirect_to :controller => "menumalist", :action => "index"
    end
  end
  
end
