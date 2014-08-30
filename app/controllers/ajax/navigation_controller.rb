class Ajax::NavigationController < ApplicationController
  
  def addnavigation
    if @user && !params.values_at(:menu_id, :title, :style).include?(nil) && @user.restaurant.menus.exists?(params[:menu_id])
      menu = @user.restaurant.menus.find(params[:menu_id])
      
      new_navigation = Navigation.create(params.permit(:style).merge({
        :menu => menu,
        :position =>menu.navigations.unscoped.last != nil ? menu.navigations.unscoped.last.id : 0
      }))

      languages = Language.find_all_by_locale(params[:title].keys)
      
      current_locale = I18n.locale
      languages.each do |language|
        I18n.locale = language.locale
        new_navigation.title = params[:title][language.locale]
      end
      I18n.locale = current_locale
      
      if params[:navigation_id] && menu.navigations.exists?(params[:navigation_id])
        new_navigation.update_attributes({
          :level => 1,
          :navigation => menu.navigations.find(params[:navigation_id]),
        })
      end
      
      new_navigation.image.set_crop_values_for_instance(params.permit(:image))
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def editnavigation
    if @user && !params.values_at(:navigation_id, :title, :style).include?(nil) && Navigation.exists?(params[:navigation_id]) && Navigation.find(params[:navigation_id]).menu.restaurant.user == @user
      navigation = Navigation.find(params[:navigation_id])
      
      if params[:delete] == "true"
        navigation.destroy
      else
        languages = Language.find_all_by_locale(params[:title].keys)
        
        current_locale = I18n.locale
        languages.each do |language|
          I18n.locale = language.locale
          navigation.title = params[:title][language.locale]
        end
        I18n.locale = current_locale
        
        navigation.style = params[:style]
        
        navigation.update_attributes(params.permit(:image))
        navigation.image.set_crop_values_for_instance(params.permit(:image, :image_crop_w, :image_crop_h, :image_crop_x, :image_crop_y))
      end
        
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def sortnavigation
    if @user && !params.values_at(:navigation_ids).include?(nil)
      params[:navigation_ids].each do |navigation_id|
        if Navigation.exists?(navigation_id[0].to_i) && Navigation.find(navigation_id[0].to_i).menu.restaurant.user == @user
          navigation = Navigation.find(navigation_id[0].to_i)
          navigation.position = navigation_id[1].to_i
          navigation.save
        end
      end
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
