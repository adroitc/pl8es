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
  
	def self.logsSession__________(session, header)
		if User.loggedIn(session) && session[:user_session_id] && Session.exists?(session[:user_session_id]) && Session.find(session[:user_session_id]).user && Session.find(session[:user_session_id]).user.id == session[:user_id]
			return true
		end
		return false
	end
  
end
