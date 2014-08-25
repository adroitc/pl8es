class Payment < ActiveRecord::Base
  belongs_to :user
  belongs_to :dailycious_plan
  has_many :dailycious_credits
  
  def paypal_payment_request
    Paypal::Payment::Request.new(
      :currency_code => :EUR,
      :description   => description,
      #:quantity      => quantity,
      :amount        => Paypal::Payment::Common::Amount.new(
        :item => quantity,
        :tax =>  quantity*0.2,
        :ship_disc => 10.0,
        :total => quantity*1.2
      ),
      :items         => [{
        :quantity => quantity,
        :name => 'Item1',
        :description => 'Awesome Item 1!',
        :amount => 1.0
      }]
    )
  end
  
  def paypal_payment_recurring_request
    Paypal::Payment::Request.new(
      :currency_code => :EUR,
      :billing_type  => :RecurringPayments,
      :billing_agreement_description => description,
      :amount        => amount
    )
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
      }
    )
  end
  
end
