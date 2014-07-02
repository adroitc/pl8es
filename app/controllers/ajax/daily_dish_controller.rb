class Ajax::DailyDishController < ApplicationController
  
  def adddailydish
    if @user && !params.values_at(:display_date, :title, :price).include?(nil)
      new_daily_dish = DailyDish.create(params.permit(:display_date, :image, :title, :price).merge({user: @user}))
      
      if params[:image]
        if new_daily_dish.image_dimensions["original"][1] >= new_daily_dish.image_dimensions["original"][0]
          new_daily_dish.image_crop_w = new_daily_dish.image_dimensions["original"].min
          new_daily_dish.image_crop_h = new_daily_dish.image_crop_w/(new_daily_dish.image_dimensions["cropped_default_retina"][0].to_f/new_daily_dish.image_dimensions["cropped_default_retina"][1].to_f)
        else
          new_daily_dish.image_crop_h = new_daily_dish.image_dimensions["original"].min
          new_daily_dish.image_crop_w = (new_daily_dish.image_dimensions["cropped_default_retina"][0].to_f/new_daily_dish.image_dimensions["cropped_default_retina"][1].to_f)*new_daily_dish.image_crop_h
        end
        new_daily_dish.image_crop_x = (new_daily_dish.image_dimensions["original"][0]-new_daily_dish.image_crop_w).to_f/2
        new_daily_dish.image_crop_y = (new_daily_dish.image_dimensions["original"][1]-new_daily_dish.image_crop_h).to_f/2
        
        new_daily_dish.save
      end
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def editdailydish
    if @user && !params.values_at(:daily_dish_id, :title, :price).include?(nil) && DailyDish.exists?(params[:daily_dish_id])
      daily_dish = DailyDish.find(params[:daily_dish_id])
      daily_dish.attributes = params.permit(:image, :title, :price)
      
      if params[:image]
        if daily_dish.image_dimensions["original"][1] >= daily_dish.image_dimensions["original"][0]
          daily_dish.image_crop_w = daily_dish.image_dimensions["original"].min
          daily_dish.image_crop_h = daily_dish.image_crop_w/(daily_dish.image_dimensions["cropped_default_retina"][0].to_f/daily_dish.image_dimensions["cropped_default_retina"][1].to_f)
        else
          daily_dish.image_crop_h = daily_dish.image_dimensions["original"].min
          daily_dish.image_crop_w = (daily_dish.image_dimensions["cropped_default_retina"][0].to_f/daily_dish.image_dimensions["cropped_default_retina"][1].to_f)*daily_dish.image_crop_h
        end
        daily_dish.image_crop_x = (daily_dish.image_dimensions["original"][0]-daily_dish.image_crop_w).to_f/2
        daily_dish.image_crop_y = (daily_dish.image_dimensions["original"][1]-daily_dish.image_crop_h).to_f/2
      end
      daily_dish.save
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def sortdailydish
    if @user && !params.values_at(:daily_dish_ids).include?(nil)
      params[:daily_dish_ids].each do |daily_dish_id|
        if DailyDish.exists?(daily_dish_id[0].to_i) && DailyDish.find(daily_dish_id[0].to_i).user == @user
          daily_dish = DailyDish.find(daily_dish_id[0].to_i)
          daily_dish.position = daily_dish_id[1].to_i
          daily_dish.save
        end
      end
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
