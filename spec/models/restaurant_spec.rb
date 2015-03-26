require 'spec_helper'

describe Restaurant do
	
	it "has a valid factory" do
		expect(build(:restaurant)).to be_valid
	end
	
	# –––– associations
	
	it { should belong_to(:user) }
	it { should have_one(:location) }
	it { should have_many(:menus) }
	it { should have_many(:categories) }
	it { should have_many(:dishes) }
	
end