class DailyciousCredit < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :payment
  
end
