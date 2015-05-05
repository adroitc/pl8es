require 'spec_helper'

describe Authentication, type: :model do
	
	it "has a valid factory" do
		expect(build(:authentication)).to be_valid
	end
	
	let(:authentication) { build(:authentication) }
	subject { authentication }
	
	describe :associations do
		it { is_expected.to belong_to(:user) }
	end
end