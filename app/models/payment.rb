class Payment < ActiveRecord::Base
  belongs_to :user
  belongs_to :dailycious_plan
  has_many :dailycious_credits
  
  has_attached_file :invoice_pdf
  
  validates_attachment_content_type :invoice_pdf,
        :content_type => ["application/pdf"]
  
  def paypal_payment_request
    if !recurring
      Paypal::Payment::Request.new(
        :currency_code => :EUR,
        :description => description,
        :amount => Paypal::Payment::Common::Amount.new(
          :item => amount,
          :tax =>  amount*0.2,
          :total => amount*1.2
        ),
        :items => [{
          :quantity => 1,
          :name => I18n.t("payment.paypal_item_dailycious_credits_title",{:c => quantity}),
          :description => I18n.t("payment.paypal_item_dailycious_credits_description",{:c => quantity}),
          :amount => amount
        }]
      )
    else
      Paypal::Payment::Request.new(
        :currency_code => :EUR,
        :billing_type => "RecurringPayments",
        :billing_agreement_description => description
        #:items => [{
        #  :quantity => 1,
        #  :name => "UNLIMITED dailis",
        #  :description => 'valid to add UNLIMITED secundary daily dish',
        #  :amount => 10.0
        #}]
      )
    end
  end
  
  def paypal_payment_recurring_profile
    Paypal::Payment::Recurring.new(
      :start_date => @user.restaurant.dailycious_plan.setup_date,
      :description => description,
      :billing => {
        :currency_code => :EUR,
        :period        => :Month,
        :frequency     => 1,
        :amount        => amount,
      },
      :items => [{
        :quantity => 1,
        :name => "UNLIMITED dailis",
        :description => 'valid to add UNLIMITED secundary daily dish',
        :amount => amount
      }]
    )
  end
  
  def save_invoice(pdf_string)
    unique_pdf_path = updated_at.strftime("%Y%m")+"-"+id.to_s.rjust(4, "0")
    
    tempfile = Tempfile.new([unique_pdf_path, ".pdf"], Rails.root.join("tmp"))
    tempfile.binmode
    tempfile.write pdf_string
    tempfile.close
    
    self.invoice_pdf = File.open tempfile.path
    save

    #tempfile.unlink
  end
  
end
