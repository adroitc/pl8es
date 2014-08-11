class User < ActiveRecord::Base
  has_one :restaurant
  has_many :devices
  has_many :sessions
  
  validates :email, :presence => true, :uniqueness => true, :length => {
    :minimum => 6,
    :maximum => 255
  }
  validates :password, :presence => true, :length => {
    :minimum => 8,
    :maximum => 255
  }
  
  has_secure_password
  
	def self.loggedIn(session)
		if session[:user_id] && User.exists?(session[:user_id])
			return true
		end
		return false
	end
  
  def send_mail(sender, subject, content)
    RestClient.post "https://api:#{ENV["MAILGUN_API"]}"\
    "@api.mailgun.net/v2/pl8.cc/messages",
      :from => "#{sender} <hi@pl8.cc>",
      :to => email,
      :subject => subject,
      :text => content
  end
  
end