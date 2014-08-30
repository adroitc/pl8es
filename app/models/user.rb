class User < ActiveRecord::Base
  has_one :restaurant
  has_many :devices
  has_many :sessions
  has_many :payments
  
  has_secure_password
  
  validates :email, :presence => true, :uniqueness => true, :length => {
    :minimum => 6,
    :maximum => 255
  }, :format => {
    :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9\.-]+\.[A-Za-z]+\Z/
  }
  validates :password, :allow_blank => true, :presence => true, :length => {
    :minimum => 8,
    :maximum => 255
  }, :format => {
    :with => /\A^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).*$\Z/
  }
  
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