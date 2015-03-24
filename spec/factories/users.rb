FactoryGirl.define do
	
	factory :user do
		sequence(:email) { |n| "user#{n}@gmail.com" }	
		password		"userpassword"
		
		factory :user_with_auth do	
			after(:create) do |user|
				create(:authentication, user: user)
			end
		end
	end
	
	factory :authentication do
		provider "facebook"
		uid "87502745645676890"
		user
	end
end