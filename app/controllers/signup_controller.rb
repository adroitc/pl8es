class SignupController < ApplicationController
  
  def index
    #render :text => t("signup.hello", :a => "8")
  end
  
  def index_post
    if !params.values_at(:name, :email, :password).include?(nil)
      @user = User.create(params.permit(:name, :email, :password))
      
      render :text => @user.to_json(only: [:name, :email]).to_s
    else
      render :text => ""
    end
  end
  
end
