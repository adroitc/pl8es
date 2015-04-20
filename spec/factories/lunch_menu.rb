FactoryGirl.define do
	factory :lunch_menu do
		dish
		restaurant
		
		date Date.today
	end
end