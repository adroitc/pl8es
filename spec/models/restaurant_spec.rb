require 'spec_helper'

describe Restaurant do
	
	it "has a valid factory" do
		expect(build(:restaurant)).to be_valid
	end
	
	# –––– associations
	
	it { is_expected.to belong_to(:user) }
	it { is_expected.to have_one(:location) }
	it { is_expected.to have_many(:menus) }
	it { is_expected.to have_many(:categories) }
	it { is_expected.to have_many(:dishes) }
	
end