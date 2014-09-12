class Ajax::PaymentController < ApplicationController
  
  def dasetupcreditplan
    payment_table = {
      4.to_s => 4.00,
      20.to_s => 15.00,
      30.to_s => 19.00#,
      #"unlimited" => 19.00
    }
    if @user && !params.values_at(:dacreditplan).include?(nil) && payment_table[params[:dacreditplan]] != nil
      payment_is_recurring = params[:dacreditplan].to_i == 0
      payment = Payment.create({
        :user => @user,
        :recurring => payment_is_recurring,
        :quantity => !payment_is_recurring != 0 ? params[:dacreditplan].to_i : 1,
        :dailycious_plan => !payment_is_recurring ? nil : @user.restaurant.dailycious_plan,
        :amount => payment_table[params[:dacreditplan]],
        :description => !payment_is_recurring ? t("payment.paypal_payment_description") : t("payment.paypal_payment_recurring_description"),
        :billing_contact => @user.restaurant.billing_contact && @user.restaurant.billing_contact.length > 0 ? @user.restaurant.billing_contact : @user.restaurant.name
      })
      if payment_is_recurring
        @user.restaurant.dailycious_plan.update_attributes({
          :activated => true,
          :setup_date => Date.today
        })
      end
      paypal_req = Paypal::Express::Request.new(
        :username   => ENV["PAYPAL_USERNAME"],
        :password   => ENV["PAYPAL_PASSWORD"],
        :signature  => ENV["PAYPAL_SIGNATURE"]
      )
      response = paypal_req.setup(
        payment.paypal_payment_request,
        url_for({:controller => "ajax/payment", :action => "datransfercreditplan"}.merge(params.permit(:buydailydish))),
        url_for(:controller => "/dailycious", :action => "index")
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
      
      if payment.recurring
        response = paypal_req.subscribe!(params[:token], payment.paypal_payment_recurring_profile)
        
        response.recurring
        response.recurring.identifier
        
        render :json => response
        return
      else
        payment.update_attributes({
          :paypal_payer_id => params[:PayerID]
        })
        
        response = paypal_req.checkout!(
          params[:token],
          params[:PayerID],
          payment.paypal_payment_request
        )
         
        if response.ack == "Success" && payment.description == t("payment.paypal_payment_description")
          @payment = payment
          invoice_pdf_string = WickedPdf.new.pdf_from_string(
            render_to_string("/invoice/pdf"),
            :encoding => "utf8"
            #:layout => false,
            #:page_size => "Letter",
            #:lowquality => false,
            #:handlers => [:erb],
            #:formats => [:html],
            #:margin => {
            #  :top    => 5,
            #  :bottom => 0,
            #  :left   => 0,
            #  :right  => 0
            #},
            #:orientation => "Portrait",
            #:disposition => "attachment"
          )
          @payment.save_invoice invoice_pdf_string
          if @payment.invoice_pdf.exists?
            payment.update_attributes({
              :successful => true,
            })
            
            @user.send_mail(t("email.payment_send"), t("email.payment_subj"), t("email.payment_msg",{:n=>@user.restaurant.name,:l=>@payment.invoice_pdf.url}))
          
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
        end
      end
      
      redirect_to :controller => "/dailycious", :action => "index"
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
