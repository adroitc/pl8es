class Ajax::NavigationController < ApplicationController
  
  def addnavigation
    if User.loggedIn(session) && !params.values_at(:menu_id, :title).include?(nil)
      @user = User.find(session[:user_id])
      
      languages = Language.find_all_by_locale(params[:title].keys)
      if @user.menus.exists?(params[:menu_id]) && languages.count > 0 && languages.count == params[:title].count
        menu = @user.menus.find(params[:menu_id])
        
        navigation_new = Navigation.create(:style => "default")
        
        if params[:image]
          navigation_new.image = params[:image]
          
          if navigation_new.image_dimensions["original"][1] >= navigation_new.image_dimensions["original"][0]
            navigation_new.image_crop_w = navigation_new.image_dimensions["original"].min
            navigation_new.image_crop_h = navigation_new.image_crop_w/(navigation_new.image_dimensions["cropped_default_retina"][0].to_f/navigation_new.image_dimensions["cropped_default_retina"][1].to_f)
          else
            navigation_new.image_crop_h = navigation_new.image_dimensions["original"].min
            navigation_new.image_crop_w = (navigation_new.image_dimensions["cropped_default_retina"][0].to_f/navigation_new.image_dimensions["cropped_default_retina"][1].to_f)*navigation_new.image_crop_h
          end
          navigation_new.image_crop_x = (navigation_new.image_dimensions["original"][0]-navigation_new.image_crop_w).to_f/2
          navigation_new.image_crop_y = (navigation_new.image_dimensions["original"][1]-navigation_new.image_crop_h).to_f/2
        end
        
        current_locale = I18n.locale
        
        languages.each do |language|
          I18n.locale = language.locale
          navigation_new.title = params[:title][language.locale]
        end
        
        I18n.locale = current_locale
        
        if params[:navigation_id] && menu.navigations.exists?(params[:navigation_id])
          navigation_new.level = 1
          navigation_new.menu = menu
          navigation = menu.navigations.find(params[:navigation_id])
          if navigation.sub_navigations.count > 0 && navigation.sub_navigations.last.position != nil
            navigation_new.position = navigation.sub_navigations.last.position+1
          end
          navigation.sub_navigations.push(navigation_new)
          navigation.save
        else
          navigation_new.level = 0
          if menu.navigations.count > 0 && menu.navigations.last.position != nil
            navigation_new.position = menu.navigations.last.position+1
          end
          menu.navigations.push(navigation_new)
          menu.save
        end
        
        render :json => {:status => "success"}
        return
      end
    end
    render :json => {:status => "invalid"}
  end
  
  def editnavigation
    if User.loggedIn(session) && !params.values_at(:navigation_id, :title).include?(nil)
      @user = User.find(session[:user_id])
      
      languages = Language.find_all_by_locale(params[:title].keys)
      if Navigation.exists?(params[:navigation_id]) && Navigation.find(params[:navigation_id]).menu.user == @user && languages.count > 0 && languages.count == params[:title].count
        navigation = Navigation.find(params[:navigation_id])
        
        if params[:image]
          navigation.image = params[:image]
          
          if navigation.image_dimensions["original"][1] >= navigation.image_dimensions["original"][0]
            navigation.image_crop_w = navigation.image_dimensions["original"].min
            navigation.image_crop_h = navigation.image_crop_w/(navigation.image_dimensions["cropped_default_retina"][0].to_f/navigation.image_dimensions["cropped_default_retina"][1].to_f)
          else
            navigation.image_crop_h = navigation.image_dimensions["original"].min
            navigation.image_crop_w = (navigation.image_dimensions["cropped_default_retina"][0].to_f/navigation.image_dimensions["cropped_default_retina"][1].to_f)*navigation.image_crop_h
          end
          navigation.image_crop_x = (navigation.image_dimensions["original"][0]-navigation.image_crop_w).to_f/2
          navigation.image_crop_y = (navigation.image_dimensions["original"][1]-navigation.image_crop_h).to_f/2
        elsif !params.values_at(:image_crop_w, :image_crop_h, :image_crop_x, :image_crop_y).include?(nil)
          if params[:image_crop_w].to_i+params[:image_crop_x].to_i > navigation.image_dimensions["original"][0]
            params[:image_crop_x] = navigation.image_dimensions["original"][0]-params[:image_crop_w].to_i
          end
          if params[:image_crop_h].to_i+params[:image_crop_y].to_i > navigation.image_dimensions["original"][1]
            params[:image_crop_y] = navigation.image_dimensions["original"][1]-params[:image_crop_h].to_i
          end
          
          navigation.attributes = params.permit(:image_crop_w, :image_crop_h, :image_crop_x, :image_crop_y)
          if navigation.image_crop_w_changed? || navigation.image_crop_h_changed? || navigation.image_crop_x_changed? || navigation.image_crop_y_changed?
            navigation.save
            navigation.update_attributes({:image_crop_processed => false})
            navigation.image.reprocess!
            navigation.update_attributes({:image_crop_processed => true})
          else
          end
        end
        
        current_locale = I18n.locale
        
        languages.each do |language|
          I18n.locale = language.locale
          navigation.title = params[:title][language.locale]
        end
        navigation.save
        
        I18n.locale = current_locale
        render :json => {:status => "success"}
        return
      end
    end
    render :json => {:status => "invalid"}
  end
  
  def sortnavigation
    if User.loggedIn(session) && !params.values_at(:navigation_ids).include?(nil)
      @user = User.find(session[:user_id])
      
      params[:navigation_ids].each do |navigation_id|
        if Navigation.exists?(navigation_id[0].to_i) && Navigation.find(navigation_id[0].to_i).menu.user == @user
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
