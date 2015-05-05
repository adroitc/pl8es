require 'spec_helper'

describe Offer, type: :model do
	
	it "has valid factories" do
		expect(build(:offer)).to be_valid
		expect(build(:biweekly_offer)).to be_valid
		expect(build(:daily_offer)).to be_valid
		expect(build(:static_offer)).to be_valid
	end
	
	let(:offer) { build(:offer) }
	subject { offer }
	
	describe :associations do
		it { is_expected.to belong_to(:dish) }
	end
	
	describe :validations do
		describe "when start_date is not present" do
			before { offer.start_date = nil }
			it { is_expected.not_to be_valid }
		end
		
		describe "when end_date is not present" do
			before { offer.end_date = nil }
			it { is_expected.not_to be_valid }
		end
		
		describe "when every is not present" do
			before { offer.end_date = nil }
			it { is_expected.not_to be_valid }
		end
		
		describe "when dish is not present" do
			before { offer.dish = nil }
			it { is_expected.not_to be_valid }
		end
		
		describe "when every is something else than 'day' & 'week'" do
			before { offer.every = 'monthly' }
			it { is_expected.not_to be_valid }
		end
		
		describe "when dish, start_date, end_date & every are present" do
			it { is_expected.to be_valid }
		end
	end
	
	describe :methods do
		describe "#dates" do
			it "returns all dates in the offer time span" do
				expect(build(:static_offer).dates.to_s).to eq("[Mon, 29 Dec 2014, Mon, 05 Jan 2015, Mon, 12 Jan 2015, Mon, 19 Jan 2015, Mon, 26 Jan 2015, Mon, 02 Feb 2015, Mon, 09 Feb 2015]")
			end
		end
	end
end
