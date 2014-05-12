class AjaxController < ApplicationController
  
  def editdesign
    if User.loggedIn(session) && !params.values_at(:background, :bar_background, :nav_text, :nav_text_active, :supportedFont_id).include?(nil)
      @user = User.find(session[:user_id])
      
      menuColor = @user.menuColor
      
      menuColor.attributes = params.permit(:background, :bar_background, :nav_text, :nav_text_active).merge({
        bev_background: params[:nav_text],
        bev_background_selected: params[:bar_background],
        bev_background_active: params[:bar_background],
        bev_text: params[:bar_background],
        bev_text_selected: params[:nav_text],
        bev_text_active: params[:bar_background],
        
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
      
      menuColor.save
      
      if SupportedFont.exists?(params[:supportedFont_id])
        @user.supportedFont = SupportedFont.find(params[:supportedFont_id])
      end
      
      if params[:appmain_image]
        @user.appmain_image = params[:appmain_image]
        
        if @user.appmain_image_dimensions["original"][1] >= @user.appmain_image_dimensions["original"][0]
          @user.appmain_image_crop_w = @user.appmain_image_dimensions["original"].min
          @user.appmain_image_crop_h = @user.appmain_image_crop_w/(@user.appmain_image_dimensions["cropped_default_retina"][0].to_f/@user.appmain_image_dimensions["cropped_default_retina"][1].to_f)
        else
          @user.appmain_image_crop_h = @user.appmain_image_dimensions["original"].min
          @user.appmain_image_crop_w = (@user.appmain_image_dimensions["cropped_default_retina"][0].to_f/@user.appmain_image_dimensions["cropped_default_retina"][1].to_f)*@user.appmain_image_crop_h
        end
        @user.appmain_image_crop_x = (@user.appmain_image_dimensions["original"][0]-@user.appmain_image_crop_w).to_f/2
        @user.appmain_image_crop_y = (@user.appmain_image_dimensions["original"][1]-@user.appmain_image_crop_h).to_f/2
      end
      
      @user.save
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
