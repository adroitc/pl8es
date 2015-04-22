require 'spec_helper'

describe LunchMenusController, type: :controller do
	
	before { login_user(create(:user_with_restaurant)) }
	
	describe "GET #index" do
		before { get :index }
		let(:lunch_menus) { create_pair :lunch_menu }
		
		it "populates @lunch_menus" do
			expect(lunch_menus).to match_array assigns(:lunch_menus)
		end
		
		it "renders :index" do
			expect(response).to render_template :index
		end
	end
	
	describe "xhr GET #new" do
		before { xhr :get, :new }
		
		it "renders :new" do
			expect(response).to render_template :new
		end
		
		it "renders the _form partial"
		
		it "assigns a new LunchMenu object to @lunch_menu" do
			expect(assigns(:lunch_menu)).to be_a_new(LunchMenu)
		end
	end
	
end
