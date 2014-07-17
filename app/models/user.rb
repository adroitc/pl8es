class User < ActiveRecord::Base
  has_one :restaurant
  has_many :devices do
    def actives()
      where(["updated_at >= (?)", DateTime.now-31.days])
    end
  end
  
  validates :email, :uniqueness => true, :length => {
    :maximum => 28
  }
  
	def self.loggedIn(session)
		if session[:user_id] && User.exists?(id: session[:user_id])
			return true
		end
		return false
	end
  
end