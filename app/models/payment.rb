class Payment < ActiveRecord::Base
  belongs_to :user
  belongs_to :dailycious_plan
  has_many :dailycious_credits
  
end
