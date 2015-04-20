require 'spec_helper'

describe LunchMenusHelper, type: :helper do
	describe "#get_week_range(date)" do
		it "formats the week range of a date into a nice string" do
			expect(helper.get_week_range("2015-04-20".to_date)).to eq("April 20, 2015 - April 26, 2015")
		end
	end
end
