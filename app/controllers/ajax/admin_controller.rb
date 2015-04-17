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
