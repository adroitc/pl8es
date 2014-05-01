class AjaxController < ApplicationController
  
  def editdesign
    if User.loggedIn(session) && !params.values_at(:background, :bar_background, :nav_text, :nav_text_active).include?(nil)
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
      
      if params[:appmain_image]
        @user.appmain_image = params[:appmain_image]
        
        if @user.appmain_image_dimensions["original"][1] >= @user.appmain_image_dimensions["original"][0]
          @user.appmain_image_crop_w = @user.appmain_image_dimensions["original"].min
          @user.appmain_image_crop_h = @user.appmain_image_crop_w/(@user.appmain_image_dimensions["cropped_retina"][0].to_f/@user.appmain_image_dimensions["cropped_retina"][1].to_f)
        else
          @user.appmain_image_crop_h = @user.appmain_image_dimensions["original"].min
          @user.appmain_image_crop_w = (@user.appmain_image_dimensions["cropped_retina"][0].to_f/@user.appmain_image_dimensions["cropped_retina"][1].to_f)*@user.appmain_image_crop_h
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
  
  def addmenu
    if User.loggedIn(session) && !params.values_at(:title, :from_time, :to_time, :languages, :label).include?(nil)
      @user = User.find(session[:user_id])
      
      languages = Array.new
      params[:languages].each do |language|
        if Language.exists?(:title => language[1].strip.downcase)
          languages.push(Language.find_by_title(language[1].strip.downcase))
        end
      end
      
      if MenuLabel.exists?(params[:label]) || params[:label] != ""
        menuLabel = MenuLabel.find(params[:label])
      else
        menuLabel = nil
      end
      
      menu = Menu.create(params.permit(:title, :from_time, :to_time).merge({menuLabel: menuLabel, languages: languages, default_language: languages.first}))
      @user.menus.push(menu)
      @user.save
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def editmenu
    if User.loggedIn(session) && !params.values_at(:menu_id, :title, :from_time, :to_time, :languages, :label).include?(nil)
      @user = User.find(session[:user_id])
      
      if @user.menus.exists?(params[:menu_id])
        menu = @user.menus.find(params[:menu_id])
        
        languages = Array.new
        params[:languages].each do |language|
          if Language.exists?(:title => language[1].strip.downcase)
            languages.push(Language.find_by_title(language[1].strip.downcase))
          end
        end
        
        if MenuLabel.exists?(params[:label]) || params[:label] != ""
          menuLabel = MenuLabel.find(params[:label])
        else
          menuLabel = nil
        end
      
        menu.attributes = params.permit(:title, :from_time, :to_time).merge({languages: languages, menuLabel: menuLabel})
        menu.save
        
        render :json => {:status => "success", :p => languages}
        return
      end
    end
    render :json => {:status => "invalid"}
  end
  
  def duplicatemenu
    if User.loggedIn(session) && !params.values_at(:menu_id).include?(nil)
      @user = User.find(session[:user_id])
      
      if @user.menus.exists?(params[:menu_id])
        menu = @user.menus.find(params[:menu_id])
        
        menu_dup = menu.dup
        menu_dup.title = menu.title+" 2"
        menu_dup.save
        
        render :json => {:status => "success"}
        return
      end
    end
    render :json => {:status => "invalid"}
  end
  
  def deletemenu
    if User.loggedIn(session) && !params.values_at(:menu_id).include?(nil)
      @user = User.find(session[:user_id])
      
      if @user.menus.exists?(params[:menu_id])
        @user.menus.destroy(params[:menu_id])
        
        render :json => {:status => "success"}
        return
      end
    end
    render :json => {:status => "invalid"}
  end
  
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
            navigation_new.image_crop_h = navigation_new.image_crop_w/(navigation_new.image_dimensions["cropped_retina"][0].to_f/navigation_new.image_dimensions["cropped_retina"][1].to_f)
          else
            navigation_new.image_crop_h = navigation_new.image_dimensions["original"].min
            navigation_new.image_crop_w = (navigation_new.image_dimensions["cropped_retina"][0].to_f/navigation_new.image_dimensions["cropped_retina"][1].to_f)*navigation_new.image_crop_h
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
            navigation.image_crop_h = navigation.image_crop_w/(navigation.image_dimensions["cropped_retina"][0].to_f/navigation.image_dimensions["cropped_retina"][1].to_f)
          else
            navigation.image_crop_h = navigation.image_dimensions["original"].min
            navigation.image_crop_w = (navigation.image_dimensions["cropped_retina"][0].to_f/navigation.image_dimensions["cropped_retina"][1].to_f)*navigation.image_crop_h
          end
          navigation.image_crop_x = (navigation.image_dimensions["original"][0]-navigation.image_crop_w).to_f/2
          navigation.image_crop_y = (navigation.image_dimensions["original"][1]-navigation.image_crop_h).to_f/2
        elsif !params.values_at(:image_crop_w, :image_crop_h, :image_crop_x, :image_crop_y).include?(nil) && navigation.checkCropValues(params.permit(:image_crop_w, :image_crop_h, :image_crop_x, :image_crop_y))
          if params[:image_crop_w].to_i+params[:image_crop_x].to_i > navigation.image_dimensions["original"][0]
            params[:image_crop_x] = navigation.image_dimensions["original"][0]-params[:image_crop_w].to_i
          end
          if params[:image_crop_h].to_i+params[:image_crop_y].to_i > navigation.image_dimensions["original"][1]
            params[:image_crop_y] = navigation.image_dimensions["original"][1]-params[:image_crop_h].to_i
          end
          navigation.update_attributes(params.permit(:image_crop_w, :image_crop_h, :image_crop_x, :image_crop_y).merge({:image_crop_processed => false}))
          navigation.image.reprocess!
          navigation.update_attributes({:image_crop_processed => false})
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
