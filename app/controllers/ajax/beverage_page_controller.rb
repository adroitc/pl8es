class Ajax::BeveragePageController < ApplicationController
  
  def addbeveragepage
    if @user && !params.values_at(:title).include?(nil)
      new_beverage_page = BeveragePage.create(params.permit(:title).merge({
        :restaurant => @user.restaurant
      }))
      
      new_beverage_page.update_attributes(params.permit(:image))
      new_beverage_page.image.set_crop_values_for_instance(params.permit(:image))
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def editbeveragepage
    if @user && !params.values_at(:beverage_page_id, :title).include?(nil) && BeveragePage.exists?(params[:beverage_page_id]) && BeveragePage.find(params[:beverage_page_id]).restaurant.user == @user
      beverage_page = BeveragePage.find(params[:beverage_page_id])
      
      if params[:delete] == "true"
        beverage_page.destroy
      else
        beverage_page.title = params[:title]
        
        beverage_page.update_attributes(params.permit(:image))
        beverage_page.image.set_crop_values_for_instance(params.permit(:image, :image_crop_w, :image_crop_h, :image_crop_x, :image_crop_y))
      end
        
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
