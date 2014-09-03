class Ajax::BeverageController < ApplicationController
  
  def addbeveragepage
    if @user && !params.values_at(:title).include?(nil)
      new_beverage_page = BeveragePage.create(params.permit(:title).merge({
        :restaurant => @user.restaurant,
        :position => @user.restaurant.beverage_pages.unscoped.last != nil ? @user.restaurant.beverage_pages.unscoped.last.id : 0
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
      params[:beverage_page_ids].each do |beverage_page_id|
        if BeveragePage.exists?(beverage_page_id[0].to_i) && BeveragePage.find(beverage_page_id[0].to_i).restaurant.user == @user
          beverage_page = BeveragePage.find(beverage_page_id[0].to_i)
          beverage_page.position = beverage_page_id[1].to_i
          beverage_page.save
        end
      end
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def addbeveragenavigation
    if @user && !params.values_at(:beverage_page_id, :title).include?(nil) && @user.restaurant.beveragePages.exists?(params[:beverage_page_id])
      beverage_page = @user.restaurant.beveragePages.find(params[:beverage_page_id])
      
      new_baverage_navigation = BeverageNavigation.new({
        :beverage_page => beverage_page,
        :position => beverage_page.beverage_navigations.unscoped.last != nil ? beverage_page.beverage_navigations.unscoped.last.id : 0
      })

      languages = Language.find_all_by_locale(params[:title].keys)
      
      current_locale = I18n.locale
      languages.each do |language|
        I18n.locale = language.locale
        new_baverage_navigation.title = params[:title][language.locale]
      end
      I18n.locale = current_locale
      
      new_baverage_navigation.save
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def editbeveragenavigation
    if @user && !params.values_at(:beverage_navigation_id, :title).include?(nil) && BeverageNavigation.exists?(params[:beverage_navigation_id]) && BeverageNavigation.find(params[:beverage_navigation_id]).beverage_page.restaurant.user == @user
      beverage_navigation = BeverageNavigation.find(params[:beverage_navigation_id])
      
      if params[:delete] == "true"
        beverage_navigation.destroy
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
  
  def sortbeveragenavigation
    if @user && !params.values_at(:beverage_navigation_ids).include?(nil)
      params[:beverage_navigation_ids].each do |beverage_navigation_id|
        if BeverageNavigation.exists?(beverage_navigation_id[0].to_i) && BeverageNavigation.find(beverage_navigation_id[0].to_i).beverage_page.restaurant.user == @user
          beverage_navigation = BeverageNavigation.find(beverage_navigation_id[0].to_i)
          beverage_navigation.position = beverage_navigation_id[1].to_i
          beverage_navigation.save
        end
      end
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def addbeverage
    if @user && !params.values_at(:beverage_navigation_id, :title, :price, :amount).include?(nil) && BeverageNavigation.exists?(params[:beverage_navigation_id]) && BeverageNavigation.find(params[:beverage_navigation_id]).beverage_page.restaurant.user == @user
      beverage_navigation = BeverageNavigation.find(params[:beverage_navigation_id])
      
      new_baverage = Beverage.create(params.permit(:price, :amount).merge({
        :position => beverage_navigation.beverages.unscoped.last != nil ? beverage_navigation.beverages.unscoped.last.id : 0
      }))
      beverage_navigation.beverages.push(new_baverage)

      languages = Language.find_all_by_locale(params[:title].keys)
      
      current_locale = I18n.locale
      languages.each do |language|
        I18n.locale = language.locale
        new_baverage.title = params[:title][language.locale]
      end
      I18n.locale = current_locale
      
      new_baverage.save
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def editbeverage
    if @user && !params.values_at(:beverage_id, :title, :price, :amount).include?(nil) && Beverage.exists?(params[:beverage_id]) && Beverage.find(params[:beverage_id]).beverage_navigation.beverage_page.restaurant.user == @user
      beverage = Beverage.find(params[:beverage_id])
      
      if params[:delete] == "true"
        beverage.destroy
      else
        beverage.attributes = params.permit(:price, :amount)
        
        languages = Language.find_all_by_locale(params[:title].keys)
        
        current_locale = I18n.locale
        languages.each do |language|
          I18n.locale = language.locale
          beverage.title = params[:title][language.locale]
        end
        I18n.locale = current_locale
        
        beverage.save
      end
        
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def sortbeverage
    if @user && !params.values_at(:beverage_ids).include?(nil)
      params[:beverage_ids].each do |beverage_ids|
        if Beverage.exists?(beverage_ids[0].to_i) && Beverage.find(beverage_ids[0].to_i).beverage_navigation.beverage_page.restaurant.user == @user
          beverage = Beverage.find(beverage_ids[0].to_i)
          beverage.position = beverage_ids[1].to_i
          beverage.save
        end
      end
      
      render :json => {:status => "success", :test => params}
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
