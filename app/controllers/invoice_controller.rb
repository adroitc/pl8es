class InvoiceController < ApplicationController
  
  def invoice_pdf
    render :pdf => WickedPdf.new.pdf_from_string(
      render_to_string("invoice/invoice_pdf")
    )
  end
  
end
