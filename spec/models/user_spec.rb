require 'spec_helper'

describe User do
	before { @user = build(:user) }
	
	subject { @user }
	
	describe "when email is not present" do
		before { @user.email = nil }
		it { should_not be_valid }
	end
	
	describe "when password is not present" do
		before { @user.password = nil }
		it { should_not be_valid }
	end
	
	describe "when email & password are present" do
		it { should be_valid }
	end
	
	it "should have encrypted password after save" do
		@user.save
		expect(@user.encrypted_password).to be_truthy
	end
end