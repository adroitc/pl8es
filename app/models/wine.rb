class Wine < ActiveRecord::Base
  belongs_to :user
  
  translates :title, :type, :country, :description
  
end
