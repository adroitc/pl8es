class AddPdfToPayments < ActiveRecord::Migration
  def self.up
    add_attachment :payments, :invoice_pdf
  end

  def self.down
    remove_attachment :payments, :invoice_pdf
  end
end
