require 'spec_helper'

describe RestaurantsController, type: :controller do
	
	describe "GET #index" do
		before { get :index }
		let(:restaurants) { create_pair :restaurant }
		
		it "populates @restaurants" do
			expect(restaurants).to match_array assigns(:restaurants)
		end
		it "renders :index" do
			expect(response).to render_template :index
		end
		it "renders the :dailycious layout" do
			expect(response).to render_template "layouts/dailycious"
		end
	end
	
	describe "GET #show" do
		let(:restaurant) { create :restaurant }
		before { get :show, id: restaurant }
		
		it "assigns the requested Restaurant as @restaurant" do
			expect(restaurant).to eq assigns(:restaurant)
		end
		it "renders :show" do
			expect(response).to render_template :show
		end
	end
	
	describe "GET #new" do
		context "user signed in" do
			
			context "user already has a restaurant" do
				before do
					login_user create(:user_with_restaurant)
					get :new
				end
				
				it "redirect to dashboard" do
					expect(response).to redirect_to dashboard_index_path
				end
			end
			
			context "user has no restaurant" do
				before do
					login_user
					get :new
				end
				
				it "assigns a new Restaurant object to @restaurant" do
					expect(assigns(:restaurant)).to be_a_new(Restaurant)
				end
				it "renders :new" do
					expect(response).to render_template :new
				end
			end
		end
		
		context "user signed out" do
			before { get :new }
			it "redirects to login page" do
				expect(response).to redirect_to new_user_session_path
			end
		end
	end
	
	describe "POST #create" do
		before { login_user }
		let(:restaurant_attributes) { attributes_for(:restaurant) }
		
		def do_post(attributes = restaurant_attributes)
			post :create, restaurant: attributes
		end
		
		context "with valid data" do
			it "creates the restaurant" do
				do_post
				expect(assigns(:restaurant)).not_to be_a_new(Restaurant)
			end
			it "redirects to the new restaurant" do
				do_post
				expect(response).to redirect_to restaurant_path(assigns(:restaurant))
			end
		end
		
		context "with invalid data" do
			before { do_post(restaurant_attributes.merge({:name => nil})) }
			
			it "re-renders :new" do
				expect(response).to render_template :new
			end
			it "does not create the restaurant" do	
				expect(assigns(:restaurant)).to be_a_new(Restaurant)
			end
		end
	end
end