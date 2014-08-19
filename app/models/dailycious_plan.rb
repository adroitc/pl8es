class DailyciousPlan < ActiveRecord::Base
  belongs_to :restaurant
  has_many :payments
  
end
