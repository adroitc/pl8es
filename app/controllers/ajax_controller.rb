class AjaxController < ApplicationController
  
  def signup
    if !User.loggedIn(session) && !params.values_at(:name, :email, :password).include?(nil)
      @user = User.create(params.permit(:name, :email, :password))
      
      if @user.errors.count == 0 && !@user.blank?
        
        download_code = SecureRandom.hex(3).upcase
        while User.find_by_download_code(download_code).present?
          download_code = SecureRandom.hex(3).upcase
        end
        @user.download_code = download_code
        @user.save
        
        session[:user_id] = @user.id
        
        render :json => {:status => "success"}
        return
      end
    end
    render :json => {:status => "invalid"}
  end
  
  def login
    if !User.loggedIn(session) && !params.values_at(:email, :password).include?(nil)
      @user = User.find_by_email_and_password(params[:email],params[:password])
      
      if !@user.blank?
        session[:user_id] = @user.id
        render :json => {:status => "success"}
        return
      end
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
      
      menu = Menu.create(params.permit(:title, :from_time, :to_time).merge({menuLabel: menuLabel, languages: languages}))
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
        
        navigation_new = Navigation.create()
        
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
        elsif params[:image_crop_w] && params[:image_crop_h] && params[:image_crop_x] && params[:image_crop_y]
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
  
  def adddish
    if User.loggedIn(session) && !params.values_at(:navigation_id, :title).include?(nil)
      @user = User.find(session[:user_id])
      
      languages = Language.find_all_by_locale(params[:title].keys)
      
      if Navigation.exists?(params[:navigation_id]) && Navigation.find(params[:navigation_id]).menu.user == @user && languages.count > 0 && languages.count == params[:title].count
        new_dish = Dish.create()
        
        if params[:image]
          new_dish.image = params[:image]
          
          if new_dish.image_dimensions["original"][1] >= new_dish.image_dimensions["original"][0]
            new_dish.image_crop_w = new_dish.image_dimensions["original"].min
            new_dish.image_crop_h = new_dish.image_crop_w/(new_dish.image_dimensions["cropped_retina"][0].to_f/new_dish.image_dimensions["cropped_retina"][1].to_f)
          else
            new_dish.image_crop_h = new_dish.image_dimensions["original"].min
            new_dish.image_crop_w = (new_dish.image_dimensions["cropped_retina"][0].to_f/new_dish.image_dimensions["cropped_retina"][1].to_f)*new_dish.image_crop_h
          end
          new_dish.image_crop_x = (new_dish.image_dimensions["original"][0]-new_dish.image_crop_w).to_f/2
          new_dish.image_crop_y = (new_dish.image_dimensions["original"][1]-new_dish.image_crop_h).to_f/2
        end
        
        current_locale = I18n.locale
        
        languages.each do |language|
          I18n.locale = language.locale
          new_dish.title = params[:title][language.locale]
        end
        
        I18n.locale = current_locale
        
        navigation = Navigation.find(params[:navigation_id])
        navigation.dishes.push(new_dish)
        navigation.save
        
        render :json => {:status => "success"}
        return
      end
    end
    render :json => {:status => "invalid"}
  end
  
  def editdish
    if User.loggedIn(session) && !params.values_at(:dish_id, :title).include?(nil)
      @user = User.find(session[:user_id])
      
      languages = Language.find_all_by_locale(params[:title].keys)
      if Dish.exists?(params[:dish_id]) && Dish.find(params[:dish_id]).navigation.menu.user == @user && languages.count > 0 && languages.count == params[:title].count
        dish = Dish.find(params[:dish_id])
        
        if params[:image]
          dish.image = params[:image]
          
          if dish.image_dimensions["original"][1] >= dish.image_dimensions["original"][0]
            dish.image_crop_w = dish.image_dimensions["original"].min
            dish.image_crop_h = dish.image_crop_w/(dish.image_dimensions["cropped_retina"][0].to_f/dish.image_dimensions["cropped_retina"][1].to_f)
          else
            dish.image_crop_h = dish.image_dimensions["original"].min
            dish.image_crop_w = (dish.image_dimensions["cropped_retina"][0].to_f/dish.image_dimensions["cropped_retina"][1].to_f)*dish.image_crop_h
          end
          dish.image_crop_x = (dish.image_dimensions["original"][0]-dish.image_crop_w).to_f/2
          dish.image_crop_y = (dish.image_dimensions["original"][1]-dish.image_crop_h).to_f/2
        elsif params[:image_crop_w] && params[:image_crop_h] && params[:image_crop_x] && params[:image_crop_y]
          if params[:image_crop_w].to_i+params[:image_crop_x].to_i > dish.image_dimensions["original"][0]
            params[:image_crop_x] = dish.image_dimensions["original"][0]-params[:image_crop_w].to_i
          end
          if params[:image_crop_h].to_i+params[:image_crop_y].to_i > dish.image_dimensions["original"][1]
            params[:image_crop_y] = dish.image_dimensions["original"][1]-params[:image_crop_h].to_i
          end
          dish.update_attributes(params.permit(:image_crop_w, :image_crop_h, :image_crop_x, :image_crop_y).merge({:image_crop_processed => false}))
          dish.image.reprocess!
          dish.update_attributes({:image_crop_processed => false})
        end
        
        current_locale = I18n.locale
        
        languages.each do |language|
          I18n.locale = language.locale
          dish.title = params[:title][language.locale]
        end
        
        dish.save
        
        render :json => {:status => "success"}
        return
      end
    end
    render :json => {:status => "invalid"}
  end
  
  def sortdish
    if User.loggedIn(session) && !params.values_at(:dish_ids).include?(nil)
      @user = User.find(session[:user_id])
      
      params[:dish_ids].each do |dish_id|
        if Dish.exists?(dish_id[0].to_i) && Dish.find(dish_id[0].to_i).navigation.menu.user == @user
          dish = Dish.find(dish_id[0].to_i)
          dish.position = dish_id[1].to_i
          dish.save
        end
      end
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
