FactoryGirl.define do	
	factory :user do
		sequence(:email) { |n| "user#{n}@gmail.com" }	
		password		"userpassword"
		
		factory :confirmed_user do
	    after(:create) { |user| user.confirm! }
	  end
		
		factory :user_with_auth do	
			before(:create) do |user|
				user.skip_confirmation!
			end
			after(:create) do |user|
				create(:authentication, user: user)
			end
		end
		
		factory :user_with_restaurant, parent: :confirmed_user do
			after(:create) do |user|
				create(:restaurant, user: user)
			end
		end
	end
	
	factory :admin do
		sequence(:email) { |n| "admin#{n}@gmail.com" }
		password "adminpassword"
		type "Admin"
		
		factory :confirmed_admin do
			after(:create) { |admin| admin.confirm! }
		end
	end
end