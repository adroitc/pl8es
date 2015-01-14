class SignupController < ApplicationController
  
  def index
    if @user
      redirect_to profile_index_path
    end
  end
  
  def restaurant
    if @user
      redirect_to profile_index_path
    elsif !session[:signup] || !params.values_at(:name).include?(nil)
      redirect_to signup_index_path
    end
  end
  
  def user
    if @user
      redirect_to profile_index_path
    elsif !session[:signup] || !params.values_at(:name).include?(nil)
      redirect_to signup_index_path
    elsif !params.values_at(:address, :zip, :city, :country).include?(nil)
      redirect_to signup_restaurant_path
    end
  end
  
end
