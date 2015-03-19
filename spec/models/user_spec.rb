require 'spec_helper'

describe User do
	
	it "has a valid factory" do
		expect(build(:user)).to be_valid
	end
	
	let(:user) { build(:user) }
	
	subject { user }
	
	# –––– validations
	
	describe "when email is not present" do
		before { user.email = nil }
		it { should_not be_valid }
	end
	
	describe "when password is not present" do
		before { user.password = nil }
		it { should_not be_valid }
	end
	
	describe "when password is too short" do
		before { user.password = "1234567" }
		it { should_not be_valid }
	end
	
	describe "when email & password are present" do
		it { should be_valid }
	end
	
	it "should have encrypted password after save" do
		user.save
		expect(user.encrypted_password).to be_truthy
	end
	
	# –––– associations
	
	it { should have_one(:restaurant) }
	it { should have_many(:authentications) }
	it { should have_many(:sessions) }
	it { should have_many(:devices) }
end