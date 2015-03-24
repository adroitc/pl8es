require 'spec_helper'

describe Authentication do
	
	it "has a valid factory" do
		expect(build(:authentication)).to be_valid
	end
	
	# –––– associations
	
	it { should belong_to(:user) }
end