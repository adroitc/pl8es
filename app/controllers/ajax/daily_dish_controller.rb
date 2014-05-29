class Ajax::DailyDishController < ApplicationController
  
  def adddailydish
    if User.loggedIn(session) && !params.values_at(:display_date, :title, :price).include?(nil)
      @user = User.find(session[:user_id])
      
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
    if User.loggedIn(session) && !params.values_at(:daily_dish_id, :title, :price).include?(nil)
      @user = User.find(session[:user_id])
      
      if DailyDish.exists?(params[:daily_dish_id])
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
    end
    render :json => {:status => "invalid"}
  end
  
end
