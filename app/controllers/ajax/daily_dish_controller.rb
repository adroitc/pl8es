class Ajax::DailyDishController < ApplicationController
  
  def adddailydish
    if @user && !params.values_at(:display_date, :title, :price).include?(nil)
      params[:price] = ("%.2f" % params[:price].gsub(",", ".")).gsub(".", ",")
      
      new_daily_dish = DailyDish.create(params.permit(:display_date, :image, :title, :price).merge({
        :restaurant => @user.restaurant
      }))
      new_daily_dish.image.set_crop_values_for_instance(params.permit(:image))
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def editdailydish
    if @user && !params.values_at(:daily_dish_id, :title, :price).include?(nil) && DailyDish.exists?(params[:daily_dish_id]) && DailyDish.find(params[:daily_dish_id]).restaurant.user == @user
      daily_dish = DailyDish.find(params[:daily_dish_id])
      
      params[:price] = ("%.2f" % params[:price].gsub(",", ".")).gsub(".", ",")
      
      if params[:delete] == "true"
        daily_dish.destroy
      else
        daily_dish.update_attributes(params.permit(:image, :title, :price))
        daily_dish.image.set_crop_values_for_instance(params.permit(:image, :image_crop_w, :image_crop_h, :image_crop_x, :image_crop_y))
      end
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def sortdailydish
    if @user && !params.values_at(:daily_dish_ids).include?(nil)
      params[:daily_dish_ids].each do |daily_dish_id|
        if DailyDish.exists?(daily_dish_id[0].to_i) && DailyDish.find(daily_dish_id[0].to_i).restaurant.user == @user
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
