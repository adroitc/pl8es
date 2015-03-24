class Session < ActiveRecord::Base
  belongs_to :user
  belongs_to :device
  has_many :requests
  
  validates :token, :uniqueness => true
  
	def self.logsSession(session)
		if session[:user_session_id] && Session.exists?(session[:user_session_id])
			return true
		end
		return false
	end
end
