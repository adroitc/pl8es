class DailyciousCredit < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :payment
  
  def self.valid_credits
    where(:usage_date => nil)
  end
  
  def self.todays_credits
    where(:usage_date => Date.today)
  end
  
end
