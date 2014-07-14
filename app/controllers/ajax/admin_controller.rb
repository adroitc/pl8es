class Ajax::AdminController < ApplicationController
  
  def addfont
    if @user && @user.isAdmin && !params.values_at(:title, :name_navigation, :size_navigation, :name_heading, :size_heading, :name_heading_small, :size_heading_small, :name_description, :size_description, :name_price, :size_price, :name_card_tab_title, :size_card_tab_title).include?(nil)
      SupportedFont.create(params.permit(:title, :name_navigation, :size_navigation, :name_heading, :size_heading, :name_heading_small, :size_heading_small, :name_description, :size_description, :name_price, :size_price, :name_card_tab_title, :size_card_tab_title))
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def editfont
    if @user && @user.isAdmin && !params.values_at(:supportedFont_id, :title, :name_navigation, :size_navigation, :name_heading, :size_heading, :name_heading_small, :size_heading_small, :name_description, :size_description, :name_price, :size_price, :name_card_tab_title, :size_card_tab_title).include?(nil) && SupportedFont.exists?(params[:supportedFont_id])
      SupportedFont.find(params[:supportedFont_id]).update_attributes(params.permit(:title, :name_navigation, :size_navigation, :name_heading, :size_heading, :name_heading_small, :size_heading_small, :name_description, :size_description, :name_price, :size_price, :name_card_tab_title, :size_card_tab_title))
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def addcategory
    if @user && @user.isAdmin && !params.values_at(:title).include?(nil)
      new_category = Category.create()
      
      current_locale = I18n.locale
      
      Language.all.each do |language|
        I18n.locale = language.locale
        new_category.title = params[:title][language.locale]
      end
      
      I18n.locale = current_locale
      
      new_category.save
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def editcategory
    if @user && @user.isAdmin && !params.values_at(:category_id, :title).include?(nil) && Category.exists?(params[:category_id])
      category = Category.find(params[:category_id])
      
      current_locale = I18n.locale
      
      Language.all.each do |language|
        I18n.locale = language.locale
        category.title = params[:title][language.locale]
      end
      
      I18n.locale = current_locale
      
      category.save
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def addmenucolortemplate
    if @user && @user.isAdmin && !params.values_at(:background, :bar_background, :nav_text, :nav_text_active).include?(nil)
      MenuColorTemplate.create(params.permit(:background, :bar_background, :nav_text, :nav_text_active).merge({
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
      }))
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def editmenucolortemplate
    if @user && @user.isAdmin && !params.values_at(:menuColorTemplate_id, :background, :bar_background, :nav_text, :nav_text_active).include?(nil) && MenuColorTemplate.exists?(params[:menuColorTemplate_id])
      menuColorTemplate = MenuColorTemplate.find(params[:menuColorTemplate_id])
      menuColorTemplate.attributes = params.permit(:background, :bar_background, :nav_text, :nav_text_active).merge({
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
      
      if params[:preview_image]
        menuColorTemplate.preview_image = params[:preview_image]
        
        if menuColorTemplate.preview_image.present?
          if menuColorTemplate.preview_image_dimensions["original"][1] >= menuColorTemplate.preview_image_dimensions["original"][0]
            menuColorTemplate.preview_image_crop_w = menuColorTemplate.preview_image_dimensions["original"].min
            menuColorTemplate.preview_image_crop_h = menuColorTemplate.preview_image_crop_w/(menuColorTemplate.preview_image_dimensions["cropped_default_retina"][0].to_f/menuColorTemplate.preview_image_dimensions["cropped_default_retina"][1].to_f)
          else
            menuColorTemplate.preview_image_crop_h = menuColorTemplate.preview_image_dimensions["original"].min
            menuColorTemplate.preview_image_crop_w = (menuColorTemplate.preview_image_dimensions["cropped_default_retina"][0].to_f/menuColorTemplate.preview_image_dimensions["cropped_default_retina"][1].to_f)*menuColorTemplate.preview_image_crop_h
          end
          menuColorTemplate.preview_image_crop_x = (menuColorTemplate.preview_image_dimensions["original"][0]-menuColorTemplate.preview_image_crop_w).to_f/2
          menuColorTemplate.preview_image_crop_y = (menuColorTemplate.preview_image_dimensions["original"][1]-menuColorTemplate.preview_image_crop_h).to_f/2
        end
      elsif !params.values_at(:preview_image_crop_w, :preview_image_crop_h, :preview_image_crop_x, :preview_image_crop_y).include?(nil)
        if params[:preview_image_crop_w].to_i+params[:image_crop_x].to_i > menuColorTemplate.preview_image_dimensions["original"][0]
          params[:preview_image_crop_x] = menuColorTemplate.preview_image_dimensions["original"][0]-params[:preview_image_crop_w].to_i
        end
        if params[:preview_image_crop_h].to_i+params[:image_crop_y].to_i > menuColorTemplate.preview_image_dimensions["original"][1]
          params[:preview_image_crop_y] = menuColorTemplate.preview_image_dimensions["original"][1]-params[:preview_image_crop_h].to_i
        end
        menuColorTemplate.attributes = params.permit(:preview_image_crop_w, :preview_image_crop_h, :preview_image_crop_x, :preview_image_crop_y)
        if menuColorTemplate.preview_image_crop_w_changed? || menuColorTemplate.preview_image_crop_h_changed? || menuColorTemplate.preview_image_crop_x_changed? || menuColorTemplate.preview_image_crop_y_changed?
          menuColorTemplate.save
          menuColorTemplate.update_attributes({:preview_image_crop_processed => false})
          menuColorTemplate.preview_image.reprocess!
          menuColorTemplate.update_attributes({:preview_image_crop_processed => true})
        end
      end
      
      menuColorTemplate.save
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
