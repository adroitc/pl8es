class Ajax::DailyDishController < ApplicationController
  
  def adddailydish
    if current_user && !params.values_at(:display_date, :title, :price).include?(nil)
      params[:price] = params[:price] == "" ? "0.00" : ("%.2f" % params[:price].gsub(",", ".")).gsub(".", ",")
      
			daily_dish = DailyDish.new(params.permit(:display_date, :title, :price, :image).merge({
				:position => current_user.restaurant.daily_dishes.unscoped.last.present? ? current_user.restaurant.daily_dishes.unscoped.last.id : 0
			}))
			
			daily_dish.update_attributes(params.permit(:image))
			daily_dish.image.set_crop_values_for_instance(params.permit(:image))
			
			current_user.restaurant.daily_dishes << daily_dish
			current_user.save
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def editdailydish
    if current_user && !params.values_at(:daily_dish_id, :title, :price).include?(nil) && DailyDish.exists?(params[:daily_dish_id]) && DailyDish.find(params[:daily_dish_id]).restaurant.user == current_user
      daily_dish = DailyDish.find(params[:daily_dish_id])
      
      if params[:delete] == "true"
        daily_dish.destroy
      else
        params[:price] = params[:price] == "" ? "0.00" : ("%.2f" % params[:price].gsub(",", ".")).gsub(".", ",")
        daily_dish.update_attributes(params.permit(:image, :title, :price))
        daily_dish.image.set_crop_values_for_instance(params.permit(:image, :image_crop_w, :image_crop_h, :image_crop_x, :image_crop_y))
      end
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def sortdailydish
    if current_user && !params.values_at(:daily_dish_ids).include?(nil)
      params[:daily_dish_ids].each do |daily_dish_id|
        if DailyDish.exists?(daily_dish_id[0].to_i) && DailyDish.find(daily_dish_id[0].to_i).restaurant.user == current_user
          DailyDish.find(daily_dish_id[0].to_i).update_attributes({
            :position => daily_dish_id[1].to_i
          })
        end
      end
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
