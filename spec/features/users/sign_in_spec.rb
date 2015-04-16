require 'spec_helper'

# Feature: Sign in
#   As a user
#   I want to sign in
#   So I can visit protected areas of the site
feature 'Sign in', :devise do
	
	scenario 'user cannot sign in if not registered' do
		sign_in(build(:user))
		expect(page).to have_content I18n.t 'devise.failure.not_found_in_database', authentication_keys: 'email'
	end
	# Scenario: User cannot sign in if not registered
	#   Given I do not exist as a user
	#   When I sign in with valid credentials
	#   Then I see an invalid credentials message
	
	# Scenario: User can sign in with valid credentials
	#   Given I exist as a user
	#   And I have a restaurant
	#   And I am not signed in
	#   When I sign in with valid credentials
	#   Then I see a success message
	#   And I am viewing the dashboard
	scenario 'user can sign in with valid credentials' do
		sign_in(create(:user_with_restaurant))
		expect(page).to have_content I18n.t 'devise.sessions.signed_in'
		expect(current_path).to eq(dashboard_index_path)
	end
	
	# Scenario: User cannot sign in with wrong email
	#   Given I exist as a user
	#   And I am not signed in
	#   When I sign in with a wrong email
	#   Then I see an invalid email message
	scenario 'user cannot sign in with wrong email' do
		user = create(:confirmed_user)
		user.email = 'invalid@gmail.com'
		sign_in(user)
		expect(page).to have_content I18n.t 'devise.failure.not_found_in_database', authentication_keys: 'email'
	end
	
	# Scenario: User cannot sign in with wrong password
	#   Given I exist as a user
	#   And I am not signed in
	#   When I sign in with a wrong password
	#   Then I see an invalid password message
	scenario 'user cannot sign in with wrong password' do
		user = create(:confirmed_user)
		user.password = 'invalidd'
		sign_in(user)
		expect(page).to have_content I18n.t 'devise.failure.invalid', authentication_keys: 'email'
	end

end