FactoryGirl.define do
	factory :user do |f|
		f.password "foobar"
		f.password_confirmation { |u| u.password }
		f.sequence(:email) { |n| "test#{n}@example.com" }
	end
end