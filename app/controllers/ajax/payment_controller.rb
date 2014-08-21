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
        url_for(:only_path => false, :controller => "ajax/payment", :action => "datransfercreditplan"),
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
      
      redirect_to :controller => "/dailycious", :action => "index"
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
