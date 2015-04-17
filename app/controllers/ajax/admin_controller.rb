class Ajax::AdminController < ApplicationController
  
  def addlanguage
    if current_user && current_user.admin? && !params.values_at(:title, :locale).include?(nil)
      new_language = Language.create(params.permit(:title, :locale))
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def editlanguage
    if current_user && current_user.admin? && !params.values_at(:language_id, :title, :locale).include?(nil)
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
  
  def edituser
    if current_user && current_user.admin? && !params.values_at(:user_id).include?(nil)
      user = User.find(params[:user_id])
      
      if params[:delete] == "true"
        user.destroy
      end
    end
    render :json => {:status => "invalid"}
  end
  
  def add_tag
    if current_user && current_user.admin? && !params.values_at(:title).include?(nil)
      tag = Tag.create()
      
      current_locale = I18n.locale
      Language.all.each do |language|
        I18n.locale = language.locale
        tag.title = params[:title][language.locale]
      end
      I18n.locale = current_locale
      
      tag.save
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def edit_tag
    if current_user && current_user.admin? && !params.values_at(:tag_id, :title).include?(nil) && Tag.exists?(params[:tag_id])
      tag = Tag.find(params[:tag_id])
      
      if params[:delete] == "true"
        tag.destroy
      else
        current_locale = I18n.locale
        Language.all.each do |language|
          I18n.locale = language.locale
          tag.title = params[:title][language.locale]
        end
        I18n.locale = current_locale
        
        tag.save
        
        render :json => {:status => "success"}
        return
      end
    end
    render :json => {:status => "invalid"}
  end
  
  def addmenucolortemplate
    if current_user && current_user.admin? && !params.values_at(:background, :bar_background, :nav_text, :nav_text_active).include?(nil)
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
    if current_user && current_user.admin? && !params.values_at(:menuColorTemplate_id, :background, :bar_background, :nav_text, :nav_text_active).include?(nil) && MenuColorTemplate.exists?(params[:menuColorTemplate_id])
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
  
  def addingredient
    if current_user && current_user.admin? && !params.values_at(:title).include?(nil)
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
    if current_user && current_user.admin? && !params.values_at(:ingredient_id, :title).include?(nil) && Ingredient.exists?(params[:ingredient_id])
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
