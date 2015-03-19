require 'spec_helper'

describe User do
	before { @user = build(:user) }
	
	subject { @user }
	
	describe "when email is not present" do
		before { @user.email = nil }
		it { should_not be_valid }
	end
end