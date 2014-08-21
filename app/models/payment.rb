class Payment < ActiveRecord::Base
  belongs_to :user
  belongs_to :dailycious_plan
  has_many :dailycious_credits
  
  def paypal_payment_request
    payment_request = Paypal::Payment::Request.new(
      :currency_code => :EUR,
      :description   => description,
      :quantity      => quantity,
      :amount        => amount
    )
  end
  
end
