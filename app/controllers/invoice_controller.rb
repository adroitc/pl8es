class InvoiceController < ApplicationController
  
  def invoice
    @payment = Payment.last
  end
  
  def invoice_pdf
    @payment = Payment.last
    render :pdf => WickedPdf.new.pdf_from_string(
      render_to_string("invoice/invoice_pdf")
    )
  end
  
end
