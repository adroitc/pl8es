require 'spec_helper'

describe Authentication do
	
	it "has a valid factory" do
		expect(build(:authentication)).to be_valid
	end
	
	# –––– associations
	
	it { is_expected.to belong_to(:user) }
end