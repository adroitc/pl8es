require 'spec_helper'

describe Dish, type: :model do
	
	it "has a valid factory" do
		expect(build(:dish)).to be_valid
	end
	
	# –– associations
	it { is_expected.to belong_to(:restaurant) }
	
	it { is_expected.to have_many(:ingredients) }
	it { is_expected.to have_many(:dish_ingredients) }
	
	it { is_expected.to have_many(:categories) }
	it { is_expected.to have_many(:category_dishes) }
	
	it { is_expected.to have_many(:lunch_menus) }
	
	let(:dish) { build(:dish) }
	subject { dish }

# not working as expected
# 	
# 	describe "when title is not present" do
# 		before { dish.title = nil }
# 		it { is_expected.to be_valid }
# 	end
# 	
# 	describe "when description is not present" do
# 		before { dish.description = nil }
# 		it { is_expected.not_to be_valid }
# 	end
end