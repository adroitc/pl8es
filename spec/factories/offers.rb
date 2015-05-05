FactoryGirl.define do
	factory :offer do
		dish
		
		start_date Date.today
		end_date 2.months.from_now
		
		every "week"
		on ["monday"]
		
		factory :biweekly_offer do
			interval 2
		end
		
		factory :daily_offer do
			every "day"
			on nil
		end
		
		factory :static_offer do
			start_date "2014-12-27"
			end_date "2015-2-14"
		end
	end
end