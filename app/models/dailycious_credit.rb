class DailyciousCredit < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :payment
  
  def self.valid_credits
    where(:usage_date => nil)
  end
  
end
