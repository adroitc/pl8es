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
  
  def sendMail(subject, content)
    RestClient.post "https://api:#{ENV["MAILGUN_API"]}"\
    "@api.mailgun.net/v2/pl8.cc/messages",
      :from => "dailycious <hi@pl8.cc>",
      :to => email,
      :subject => "Hello",
      :text => "Hello World!"
  end
  
end