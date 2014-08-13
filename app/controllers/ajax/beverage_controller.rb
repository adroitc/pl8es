class Ajax::BeverageController < ApplicationController
  
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
  
  def sortbeveragepage
    if @user && !params.values_at(:beverage_page_ids).include?(nil)
      #params[:navigation_ids].each do |navigation_id|
      #  if Navigation.exists?(navigation_id[0].to_i) && Navigation.find(navigation_id[0].to_i).menu.restaurant.user == @user
      #    navigation = Navigation.find(navigation_id[0].to_i)
      #    navigation.position = navigation_id[1].to_i
      #    navigation.save
      #  end
      #end
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def addbeveragenavigation
    if @user && !params.values_at(:beverage_page_id, :title).include?(nil) && @user.restaurant.beveragePages.exists?(params[:beverage_page_id])
      beverage_page = @user.restaurant.beveragePages.find(params[:beverage_page_id])
      
      new_baverage_navigation = BeverageNavigation.create({
        :beveragePage_id => beverage_page.id
      })

      languages = Language.find_all_by_locale(params[:title].keys)
      
      current_locale = I18n.locale
      languages.each do |language|
        I18n.locale = language.locale
        new_baverage_navigation.title = params[:title][language.locale]
      end
      I18n.locale = current_locale
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def editbeveragenavigation
    if @user && !params.values_at(:beverage_navigation_id, :title).include?(nil) && BeveragePage.exists?(params[:beverage_navigation_id]) && BeverageNavigation.find(params[:beverage_navigation_id]).beveragePage.restaurant.user == @user
      beverage_navigation = BeverageNavigation.find(params[:beverage_navigation_id])
      
      if params[:delete] == "true"
        baverage_navigation.destroy
      else
        languages = Language.find_all_by_locale(params[:title].keys)
        
        current_locale = I18n.locale
        languages.each do |language|
          I18n.locale = language.locale
          beverage_navigation.title = params[:title][language.locale]
        end
        I18n.locale = current_locale
        
        beverage_navigation.save
      end
        
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
