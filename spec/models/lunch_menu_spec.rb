require 'spec_helper'

describe LunchMenu do
	
	it "has a valid factory" do
		expect(build(:lunch_menu)).to be_valid
	end
	
	# –––– validations
	
	let(:lunch_menu) { build(:lunch_menu) }
	subject { lunch_menu }
	
	describe "when dish_id is not present" do
		before { lunch_menu.dish_id = nil }
		it { is_expected.not_to be_valid }
	end
	
	describe "when restaurant_id is not present" do
		before { lunch_menu.restaurant_id = nil }
		it { is_expected.not_to be_valid }
	end
	
	describe "when date is not present" do
		before { lunch_menu.date = nil }
		it { is_expected.not_to be_valid }
	end
	
	describe "when dish_id, restaurant_id & date is present" do
		it { is_expected.to be_valid }
	end
	
	# –––– associations
	
	it { is_expected.to belong_to(:restaurant) }
	it { is_expected.to belong_to(:dish) }
	
end