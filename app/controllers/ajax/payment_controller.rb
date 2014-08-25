class Ajax::PaymentController < ApplicationController
  
  def dasetupcreditplan
    payment_table = {
      4.to_s => 4.00,
      20.to_s => 15.00,
      30.to_s => 19.00
    }
    if @user && !params.values_at(:dacreditplan).include?(nil) && payment_table[params[:dacreditplan]] != nil
      paypal_req = Paypal::Express::Request.new(
        :username   => ENV["PAYPAL_USERNAME"],
        :password   => ENV["PAYPAL_PASSWORD"],
        :signature  => ENV["PAYPAL_SIGNATURE"]
      )
      payment = Payment.create({
        :user => @user,
        :quantity => params[:dacreditplan].to_i,
        :amount => payment_table[params[:dacreditplan]],
        :description => "dailycious - dailys (credits)"
      })
      response = paypal_req.setup(
        payment.paypal_payment_request,
        url_for({:only_path => false, :controller => "ajax/payment", :action => "datransfercreditplan"}.merge(params.permit(:buydailydish))),
        url_for(:only_path => false, :controller => "/dailycious", :action => "index")
      )
      payment.update_attributes({
        :paypal_token => response.token
      })
      render :json => {:status => "success", :redirect => response.redirect_uri}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def datransfercreditplan
    if @user && !params.values_at(:token, :PayerID).include?(nil) && Payment.find_by_paypal_token(params[:token]) != nil && Payment.find_by_paypal_token(params[:token]).user == @user
      payment = Payment.find_by_paypal_token(params[:token])
      
      paypal_req = Paypal::Express::Request.new(
        :username   => ENV["PAYPAL_USERNAME"],
        :password   => ENV["PAYPAL_PASSWORD"],
        :signature  => ENV["PAYPAL_SIGNATURE"]
      )
      response = paypal_req.checkout!(
        params[:token],
        params[:PayerID],
        payment.paypal_payment_request
      )
      payment.update_attributes({
        :paypal_payer_id => params[:PayerID]
      })
      if response.ack == "Success" && payment.description == "dailycious - dailys (credits)"
        for i in 1..payment.quantity
          DailyciousCredit.create(
            :restaurant => @user.restaurant,
            :payment => payment
          )
        end
        
        last_daily_dish = @user.restaurant.daily_dishes.last
        
        if last_daily_dish
          todays_dailycious_credits = @user.restaurant.dailycious_credits.where(:usage_date => last_daily_dish.display_date.to_date)
          todays_daily_dishes = @user.restaurant.daily_dishes.where(:display_date => last_daily_dish.display_date)
          
          if todays_daily_dishes.count > todays_dailycious_credits.count+1 && params[:buydailydish] && params[:buydailydish] == "1"
            @user.restaurant.dailycious_credits.valid_credits.first.update_attributes({
              :usage_date => last_daily_dish.display_date.to_date
            })
          end
        end
      end
      
      redirect_to :controller => "/dailycious", :action => "index"
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
