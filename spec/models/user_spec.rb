require 'spec_helper'

describe User, type: :model do
	
	it "has valid factories" do
		expect(build(:user)).to be_valid
		expect(build(:confirmed_user)).to be_valid
		expect(build(:user_with_auth)).to be_valid
		expect(build(:user_with_restaurant)).to be_valid
		
		expect(build(:admin)).to be_valid
		expect(build(:confirmed_admin)).to be_valid
	end
	
	# –––– validations
	
	let(:user) { build(:user) }
	subject { user }
	
	describe "when email is not present" do
		before { user.email = nil }
		it { is_expected.not_to be_valid }
	end
	
	describe "when password is not present" do
		before { user.password = nil }
		it { is_expected.not_to be_valid }
	end
	
	describe "when password is too short" do
		before { user.password = "1234567" }
		it { is_expected.not_to be_valid }
	end
	
	describe "when email & password are present" do
		it { is_expected.to be_valid }
	end
	
	it "should have encrypted password after save" do
		user.save
		expect(user.encrypted_password).to be_truthy
	end
	
	# –––– associations
	
	it { is_expected.to have_one(:restaurant) }
	it { is_expected.to have_many(:authentications) }
	it { is_expected.to have_many(:sessions) }
	it { is_expected.to have_many(:devices) }
	
	describe "#admin?" do
		it "returns true as admin" do
			user.type = "Admin"
			expect(user.admin?).to be true
		end
		
		it "returns false as user" do
			user.type = "User"
			expect(user.admin?).to be false
		end
	end
end