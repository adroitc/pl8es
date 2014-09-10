class InvoiceController < ApplicationController
  
  def pdf
    if @user && Payment.exists?(params[:payment_id]) && Payment.find(params[:payment_id]).user == @user && Payment.find(params[:payment_id]).successful
      @payment = Payment.find(params[:payment_id])
      render :pdf => WickedPdf.new.pdf_from_string(
        render_to_string("invoice/pdf")
      )
    else
      raise ActionController::RoutingError.new("Not Found")
    end
  end
  
end
