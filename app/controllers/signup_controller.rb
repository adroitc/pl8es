class SignupController < ApplicationController
  
  def index
    if @user
      redirect_to :controller => "profile", :action => "index"
    elsif params[:product_referer]
      session[:signup][:product_referer] = params[:product_referer]
    end
  end
  
  def restaurant
    if @user
      redirect_to :controller => "profile", :action => "index"
    elsif !session[:signup] || !params.values_at(:name).include?(nil)
      redirect_to :controller => "signup", :action => "index"
    elsif params[:product_referer]
      session[:signup][:product_referer] = params[:product_referer]
    end
  end
  
  def user
    if @user
      redirect_to :controller => "profile", :action => "index"
    elsif !session[:signup] || !params.values_at(:name).include?(nil)
      redirect_to :controller => "signup", :action => "index"
    elsif !params.values_at(:address, :zip, :city, :country).include?(nil)
      redirect_to :controller => "signup", :action => "restaurant"
    elsif params[:product_referer]
      session[:signup][:product_referer] = params[:product_referer]
    end
  end
  
end
