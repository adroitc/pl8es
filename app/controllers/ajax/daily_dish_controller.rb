class Ajax::DailyDishController < ApplicationController
  
  def adddailydish
    if @user && !params.values_at(:display_date, :title, :price).include?(nil)
      todays_dailycious_credits = @user.restaurant.dailycious_credits.where(:usage_date => params[:display_date].to_date)
      todays_daily_dishes = @user.restaurant.daily_dishes.where(:display_date => params[:display_date].to_datetime)
      
      #if todays_daily_dishes.count == 0 || (todays_daily_dishes.count > 0 && @user.restaurant.dailycious_credits.valid_credits.count > 0)
      #  if todays_daily_dishes.count > todays_dailycious_credits.count
      #    @user.restaurant.dailycious_credits.valid_credits.first.update_attributes({
      #      :usage_date => params[:display_date]
      #    })
      #  end
      #end

      while @user.restaurant.daily_dishes.where(:display_date => params[:display_date].to_datetime).count > todays_dailycious_credits.count+1
        @user.restaurant.daily_dishes.where(:display_date => params[:display_date].to_datetime).last.destroy
      end
      
      if @user.restaurant.daily_dishes.where(:display_date => params[:display_date].to_datetime).count == todays_dailycious_credits.count+1 && @user.restaurant.dailycious_credits.valid_credits.count > 0
        @user.restaurant.dailycious_credits.valid_credits.first.update_attributes({
          :usage_date => params[:display_date]
        })
      end

      params[:price] = params[:price] == "" ? "0.00" : ("%.2f" % params[:price].gsub(",", ".")).gsub(".", ",")
      new_daily_dish = DailyDish.create(params.permit(:display_date, :image, :title, :price).merge({
        :restaurant => @user.restaurant,
        :position => @user.restaurant.daily_dishes.unscoped.last != nil ? @user.restaurant.daily_dishes.unscoped.last.id : 0
      }))
      
      new_daily_dish.update_attributes(params.permit(:image))
      new_daily_dish.image.set_crop_values_for_instance(params.permit(:image))
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def editdailydish
    if @user && !params.values_at(:daily_dish_id, :title, :price).include?(nil) && DailyDish.exists?(params[:daily_dish_id]) && DailyDish.find(params[:daily_dish_id]).restaurant.user == @user
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
