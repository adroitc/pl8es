class DailyciousController < ApplicationController
  
  def index
    if params[:token]
      paypal_req = Paypal::Express::Request.new(
        :username   => ENV["PAYPAL_USERNAME"],
        :password   => ENV["PAYPAL_PASSWORD"],
        :signature  => ENV["PAYPAL_SIGNATURE"]
      )
      render :json => paypal_req.details(params[:token])
      return
    end
    if params[:add_weeks] == "0"
      redirect_to :controller => "dailycious", :action => "index", :add_weeks => nil
    elsif !@user
      redirect_to :controller => "login", :action => "index"
    end
  end
  
end
