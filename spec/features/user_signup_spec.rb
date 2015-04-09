require 'spec_helper'

feature "User logs in" do
	scenario "without a restaurant" do
		sign_in(create(:user_with_auth))
		
		expect(page).to have_content("New Restaurant")
	end
	
	scenario "with a restaurant" do
		sign_in(create(:user_with_restaurant))
		
		expect(page).to have_content("Signed in")
	end
end