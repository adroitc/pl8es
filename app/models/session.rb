class Session < ActiveRecord::Base
  belongs_to :user
  belongs_to :device
  has_many :requests
  
	def self.logsSession(session, header)
		if User.loggedIn(session) && session[:user_session_id] && Session.exists?(session[:user_session_id]) && Session.find(session[:user_session_id]).user && Session.find(session[:user_session_id]).user.id == session[:user_id]
			return true
		end
		return false
	end
  
end
