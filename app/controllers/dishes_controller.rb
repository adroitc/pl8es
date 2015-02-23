class DishesController < ApplicationController
	
	before_filter :authenticate_user
	before_filter :get_languages, only: [:new, :create, :edit, :update, :destroy_image]
	
	def index
	end
	
	def new
		@dish = Dish.new()
	end
	
	def create
		if @user && !params.values_at(:category_id, :title, :description, :price).include?(nil) && Category.exists?(params[:category_id]) && Category.find(params[:category_id]).menu.restaurant.user == @user
			languages = Language.find_all_by_locale(params[:title].keys)
			
			category = Category.find(params[:category_id])
			new_dish = Dish.new(params.permit(:image, :price).merge({
				:restaurant => @user.restaurant,
				:menu => category.menu,
				:category => category,
				:position => category.dishes.unscoped.last != nil ? category.dishes.unscoped.last.id : 0
			}))
			
			current_locale = I18n.locale
			languages.each do |language|
				I18n.locale = language.locale
				new_dish.title = params[:title][language.locale]
				new_dish.description = params[:description][language.locale]
			end
			I18n.locale = current_locale
			
			new_dish.save
			
			new_dish.image.set_crop_values_for_instance(params.permit(:image))
			
			render :json => {:status => "success"}
			return
		end
		render :json => {:status => "invalid"}
	end
	
	def show
	end
	
	def edit
	end
	
	def update
		if @user && !params.values_at(:dish_id, :title, :description, :price, :drinks, :sides).include?(nil) && Dish.exists?(params[:dish_id]) && Dish.find(params[:dish_id]).category.menu.restaurant.user == @user
			dish = Dish.find(params[:dish_id])
			
			if params[:delete] == "true"
				dish.destroy
			else
				languages = Language.find_all_by_locale(params[:title].keys)
				
				dish.update_attributes(params.permit(:image))
				dish.image.set_crop_values_for_instance(params.permit(:image, :image_crop_w, :image_crop_h, :image_crop_x, :image_crop_y))
				
				dish.price = params[:price]
				
				current_locale = I18n.locale
				languages.each do |language|
					I18n.locale = language.locale
					dish.attributes = {
						:title => params[:title][language.locale],
						:description => params[:description][language.locale],
						:drinks => params[:drinks][language.locale],
						:sides => params[:sides][language.locale]
					}
				end
				I18n.locale = current_locale
				
				params[:dishsuggestions].each_with_index do |dishsuggestion, i|
					break if i >= 2;
					if Dish.exists?(dishsuggestion[1].to_i) && Dish.find(dishsuggestion[1].to_i).menu.user == @user && dish["dishsuggestion_"+(i+1).to_s] != Dish.find(dishsuggestion[1].to_i)
						dish.update_attribute("dishsuggestion_"+(i+1).to_s,Dish.find(dishsuggestion[1].to_i))
					else
						dish.update_attribute("dishsuggestion_"+(i+1).to_s,nil)
					end
				end
			
				dish.ingredients = []
				if params[:ingredients]
					params[:ingredients].each do |ingredient|
						if Ingredient.exists?(ingredient[0].to_i)
							dish.ingredients.push(Ingredient.find(ingredient[0].to_i))
						end
					end
				end
				
				dish.save
			end
			
			render :json => {:status => "success"}
			return
		end
		render :json => {:status => "invalid"}
	end
	
	def destroy
	end
	
	def sort
		if @user && !params.values_at(:dish_ids).include?(nil)
			params[:dish_ids].each do |dish_id|
				if Dish.exists?(dish_id[0].to_i) && Dish.find(dish_id[0].to_i).restaurant.user == @user
					Dish.find(dish_id[0].to_i).update_attributes({
						:position => dish_id[1].to_i
					})
				end
			end
			
			render :json => {:status => "success"}
			return
		end
		render :json => {:status => "invalid"}
	end
	
end
