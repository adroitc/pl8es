class Ajax::AjaxController < ApplicationController
  
  def editdesign
    if @user && !params.values_at(:menuColorTemplate_id, :background, :bar_background, :nav_text, :nav_text_active, :supportedFont_id).include?(nil)
      if MenuColorTemplate.exists?(params[:menuColorTemplate_id])
        @user.restaurant.menuColorTemplate = MenuColorTemplate.find(params[:menuColorTemplate_id])
      else
        @user.restaurant.menuColorTemplate = nil
      end
      @user.restaurant.background_type = params[:background_type]
      @user.restaurant.save
      
      @user.restaurant.menuColor.update_attributes(
        params.permit(:background, :bar_background, :nav_text, :nav_text_active).merge({
          bev_background: params[:nav_text],
          bev_background_selected: params[:bar_background],
          bev_background_active: params[:bar_background],
          bev_text: params[:bar_background],
          bev_text_selected: params[:nav_text],
          bev_text_active: params[:nav_text],
          
          nav_background: params[:bar_background],
          nav_background_selected: params[:bar_background],
          nav_background_active: params[:bar_background],
          nav_text: params[:nav_text],
          nav_text_selected: params[:nav_text_active],
          nav_text_active: params[:nav_text_active],
          
          sub_background: params[:background],
          sub_background_selected: params[:background],
          sub_background_active: params[:background],
          sub_text: params[:nav_text],
          sub_text_selected: params[:nav_text_active],
          sub_text_active: params[:nav_text_active]
        })
      )
      
      if SupportedFont.exists?(params[:supportedFont_id])
        @user.restaurant.supportedFont = SupportedFont.find(params[:supportedFont_id])
      end
      
      @user.restaurant.update_attributes(params.permit(:background_type, :appmain_image, :splashscreen_image))
      @user.restaurant.appmain_image.set_crop_values_for_instance(params.permit(:appmain_image))
      @user.restaurant.splashscreen_image.set_crop_values_for_instance(params.permit(:splashscreen_image))
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
