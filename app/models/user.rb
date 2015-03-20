class User < ActiveRecord::Base
	
	devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable,
				 :omniauthable, :omniauth_providers => [:facebook]
	
	has_many :authentications, :dependent => :destroy
	
	has_one :restaurant
	has_many :devices
	has_many :sessions, :dependent => :destroy
	
	before_create :assign_default_restaurant
	
	def send_mail(sender, subject, content)
    RestClient.post "https://api:#{ENV["MAILGUN_API"]}"\
    "@api.mailgun.net/v2/pl8.cc/messages",
      :from => "#{sender} <hi@pl8.cc>",
      :to => email,
      :subject => subject,
      :text => content
  end
	
	private
		
		def assign_default_restaurant
			self.restaurant = Restaurant.new(:name => :Default)
		end
	
end