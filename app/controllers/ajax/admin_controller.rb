class Ajax::AdminController < ApplicationController
  
  def addlanguage
    if @user && @user.isAdmin && !params.values_at(:title, :locale).include?(nil)
      new_language = Category.create(params.permit(:title, :locale))
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def editlanguage
    if @user && @user.isAdmin && !params.values_at(:language_id, :title, :locale).include?(nil)
      language = Language.find(params[:language_id])
      
      if params[:delete] == "true"
        language.destroy
      else
        language.update_attributes(params.permit(:title, :locale))
        
        render :json => {:status => "success"}
        return
      end
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
      
      if params[:delete] == "true"
        category.destroy
      else
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
    end
    render :json => {:status => "invalid"}
  end
  
  def addmenucolortemplate
    if @user && @user.isAdmin && !params.values_at(:background, :bar_background, :nav_text, :nav_text_active).include?(nil)
      MenuColorTemplate.create(params.permit(:preview_image, :background, :bar_background, :nav_text, :nav_text_active).merge({
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
      
      if params[:delete] == "true"
        menuColorTemplate.destroy
      else
        menuColorTemplate.update_attributes(params.permit(:preview_image, :background, :bar_background, :nav_text, :nav_text_active).merge({
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
        menuColorTemplate.preview_image.set_crop_values_for_instance(params.permit(:preview_image, :preview_image_crop_w, :preview_image_crop_h, :preview_image_crop_x, :preview_image_crop_y))
      end
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
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
      supportedFont = SupportedFont.find(params[:supportedFont_id])
      
      if params[:delete] == "true"
        supportedFont.destroy
      else
        supportedFont.update_attributes(params.permit(:title, :name_navigation, :size_navigation, :name_heading, :size_heading, :name_heading_small, :size_heading_small, :name_description, :size_description, :name_price, :size_price, :name_card_tab_title, :size_card_tab_title))
      end
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def addingredient
    if @user && @user.isAdmin && !params.values_at(:title).include?(nil)
      new_ingredient = Ingredient.create()
      
      current_locale = I18n.locale
      Language.all.each do |language|
        I18n.locale = language.locale
        new_ingredient.title = params[:title][language.locale]
      end
      I18n.locale = current_locale
      
      new_ingredient.save
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def editingredient
    if @user && @user.isAdmin && !params.values_at(:ingredient_id, :title).include?(nil) && Ingredient.exists?(params[:ingredient_id])
      ingredient = Ingredient.find(params[:ingredient_id])
      
      if params[:delete] == "true"
        ingredient.destroy
      else
        current_locale = I18n.locale
        Language.all.each do |language|
          I18n.locale = language.locale
          ingredient.title = params[:title][language.locale]
        end
        I18n.locale = current_locale
        
        ingredient.save
        
        render :json => {:status => "success"}
        return
      end
    end
    render :json => {:status => "invalid"}
  end
  
end
