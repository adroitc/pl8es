class Ajax::DishController < ApplicationController
  
  # get methods
  def dish
    if User.loggedIn(session) && Dish.find(params[:id]) && Dish.find(params[:id]).menu.user == User.find(session[:user_id])
      current_locale = I18n.locale
      I18n.locale = params[:language_locale]
      render :json => {
        :status => "success",
        :dish => JSON.parse(
          Dish.find(params[:id]).to_json(
            :only => [
              :id,
              :title,
              :price
            ],
            :methods => [
              :image_url
            ]
          )
        )
      }
      I18n.locale = current_locale
      return
    end
    render :json => {:status => "invalid"}
  end
  
  # post methods
  def adddish
    if User.loggedIn(session) && !params.values_at(:navigation_id, :title, :description, :price).include?(nil)
      @user = User.find(session[:user_id])
      
      languages = Language.find_all_by_locale(params[:title].keys)
      
      if Navigation.exists?(params[:navigation_id]) && Navigation.find(params[:navigation_id]).menu.user == @user && languages.count > 0 && languages.count == params[:title].count
        navigation = Navigation.find(params[:navigation_id])
        new_dish = Dish.create(:menu => navigation.menu)
        
        if params[:image]
          new_dish.image = params[:image]
          
          if new_dish.image_dimensions["original"][1] >= new_dish.image_dimensions["original"][0]
            new_dish.image_crop_w = new_dish.image_dimensions["original"].min
            new_dish.image_crop_h = new_dish.image_crop_w/(new_dish.image_dimensions["cropped_retina"][0].to_f/new_dish.image_dimensions["cropped_retina"][1].to_f)
          else
            new_dish.image_crop_h = new_dish.image_dimensions["original"].min
            new_dish.image_crop_w = (new_dish.image_dimensions["cropped_retina"][0].to_f/new_dish.image_dimensions["cropped_retina"][1].to_f)*new_dish.image_crop_h
          end
          new_dish.image_crop_x = (new_dish.image_dimensions["original"][0]-new_dish.image_crop_w).to_f/2
          new_dish.image_crop_y = (new_dish.image_dimensions["original"][1]-new_dish.image_crop_h).to_f/2
        end
        
        current_locale = I18n.locale
        
        languages.each do |language|
          I18n.locale = language.locale
          new_dish.title = params[:title][language.locale]
          new_dish.description = params[:description][language.locale]
        end
        
        new_dish.price = params[:price]
        
        I18n.locale = current_locale
        
        navigation.dishes.push(new_dish)
        navigation.save
        
        render :json => {:status => "success"}
        return
      end
    end
    render :json => {:status => "invalid"}
  end
  
  def editdish
    if User.loggedIn(session) && !params.values_at(:dish_id, :title, :description, :price, :drinks, :sides).include?(nil)
      @user = User.find(session[:user_id])
      
      languages = Language.find_all_by_locale(params[:title].keys)
      if Dish.exists?(params[:dish_id]) && Dish.find(params[:dish_id]).navigation.menu.user == @user && languages.count > 0
        dish = Dish.find(params[:dish_id])
        
        if params[:image]
          dish.image = params[:image]
          
          if dish.image_dimensions["original"][1] >= dish.image_dimensions["original"][0]
            dish.image_crop_w = dish.image_dimensions["original"].min
            dish.image_crop_h = dish.image_crop_w/(dish.image_dimensions["cropped_retina"][0].to_f/dish.image_dimensions["cropped_retina"][1].to_f)
          else
            dish.image_crop_h = dish.image_dimensions["original"].min
            dish.image_crop_w = (dish.image_dimensions["cropped_retina"][0].to_f/dish.image_dimensions["cropped_retina"][1].to_f)*dish.image_crop_h
          end
          dish.image_crop_x = (dish.image_dimensions["original"][0]-dish.image_crop_w).to_f/2
          dish.image_crop_y = (dish.image_dimensions["original"][1]-dish.image_crop_h).to_f/2
        elsif !params.values_at(:image_crop_w, :image_crop_h, :image_crop_x, :image_crop_y).include?(nil)
          if params[:image_crop_w].to_i+params[:image_crop_x].to_i > dish.image_dimensions["original"][0]
            params[:image_crop_x] = dish.image_dimensions["original"][0]-params[:image_crop_w].to_i
          end
          if params[:image_crop_h].to_i+params[:image_crop_y].to_i > dish.image_dimensions["original"][1]
            params[:image_crop_y] = dish.image_dimensions["original"][1]-params[:image_crop_h].to_i
          end
          dish.update_attributes(params.permit(:image_crop_w, :image_crop_h, :image_crop_x, :image_crop_y))
          if dish.image_crop_w_changed? || dish.image_crop_h_changed? || dish.image_crop_x_changed? || dish.image_crop_y_changed?
            dish.update_attributes({:image_crop_processed => true})
            dish.image.reprocess!
            dish.update_attributes({:image_crop_processed => false})
          end
        end
        
        dish.price = params[:price]
        
        current_locale = I18n.locale
        
        languages.each do |language|
          I18n.locale = language.locale
          dish.title = params[:title][language.locale]
          dish.description = params[:description][language.locale]
          dish.drinks = params[:drinks][language.locale]
          dish.sidedish = params[:sidedish][language.locale]
        end
        
        I18n.locale = current_locale
        
        params[:dishsuggestions].each_with_index do |dishsuggestion, i|
          break if i == 2;
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
        
        render :json => {:status => "success"}
        return
      end
    end
    render :json => {:status => "invalid"}
  end
  
  def sortdish
    if User.loggedIn(session) && !params.values_at(:dish_ids).include?(nil)
      @user = User.find(session[:user_id])
      
      params[:dish_ids].each do |dish_id|
        if Dish.exists?(dish_id[0].to_i) && Dish.find(dish_id[0].to_i).navigation.menu.user == @user
          dish = Dish.find(dish_id[0].to_i)
          dish.position = dish_id[1].to_i
          dish.save
        end
      end
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
