class User < ActiveRecord::Base
  has_one :restaurant
  has_many :devices
  has_many :sessions
  
  validates :email, :uniqueness => true, :length => {
    :maximum => 28
  }
  
	def self.loggedIn(session)
		if session[:user_id] && User.exists?(session[:user_id])
			return true
		end
		return false
	end
  
end