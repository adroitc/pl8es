class DailyciousPlan < ActiveRecord::Base
  belongs_to :restaurant
  has_many :payments
  
  def status
    if !activated
      0
    elsif activated && !setup_date
      1
    else
      1
    end
  end
  
end
