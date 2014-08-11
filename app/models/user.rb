class User < ActiveRecord::Base
  has_one :restaurant
  has_many :devices
  has_many :sessions
  
  validates :email, :uniqueness => true, :length => {
    :minimum => 6
  }
  
  validates :password, :length => {
    :minimum => 8
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