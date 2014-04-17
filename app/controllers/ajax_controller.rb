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
        
        render :text => {:status => "success"}.to_json.to_s
        return
      end
    end
    render :text => {:status => "invalid"}.to_json.to_s
  end
  
  def login
    if !User.loggedIn(session) && !params.values_at(:email, :password).include?(nil)
      @user = User.find_by_email_and_password(params[:email],params[:password])
      
      if !@user.blank?
        session[:user_id] = @user.id
        render :text => {:status => "success"}.to_json.to_s
        return
      end
    end
    render :text => {:status => "invalid"}.to_json.to_s
  end
  
  def addmenu
    if User.loggedIn(session) && !params.values_at(:title, :from_time, :to_time, :languages, :label).include?(nil)
      @user = User.find(session[:user_id])
      
      if MenuLabel.exists?(params[:label]) || params[:label] != ""
        menuLabel = MenuLabel.find(params[:label])
      else
        menuLabel = nil
      end
      
      languages = Array.new
      params[:languages].each do |language|
        if Language.exists?(:title => language[1].downcase)
          languages.push(Language.find_by_title(language[1].downcase))
        end
      end
      
      menu = Menu.create(params.permit(:title, :from_time, :to_time).merge({menuLabel: menuLabel, languages: languages}))
      @user.menus.push(menu)
      @user.save
      
      render :text => {:status => "success", :p => params[:languages]}.to_json
      return
    end
    render :text => {:status => "invalid"}.to_json
  end
  
  def editmenu
    if User.loggedIn(session) && !params.values_at(:menu_id, :title, :from_time, :to_time, :label).include?(nil)
      @user = User.find(session[:user_id])
      
      if @user.menus.exists?(params[:menu_id])
        menu = @user.menus.find(params[:menu_id])
        
        if MenuLabel.exists?(params[:label]) || params[:label] != ""
          menuLabel = MenuLabel.find(params[:label])
        else
          menuLabel = nil
        end
      
        menu.attributes = params.permit(:title, :from_time, :to_time).merge({menuLabel: menuLabel})
        menu.save
        
        render :text => {:status => "success"}.to_json
        return
      end
    end
    render :text => {:status => "invalid"}.to_json
  end
  
  def duplicatemenu
    if User.loggedIn(session) && !params.values_at(:menu_id).include?(nil)
      @user = User.find(session[:user_id])
      
      if @user.menus.exists?(params[:menu_id])
        menu = @user.menus.find(params[:menu_id])
        
        menu_dup = menu.dup
        menu_dup.title = newMenu.title+" 2"
        menu_dup.save
        
        render :text => {:status => "success"}.to_json
        return
      end
    end
    render :text => {:status => "invalid"}.to_json
  end
  
  def deletemenu
    if User.loggedIn(session) && !params.values_at(:menu_id).include?(nil)
      @user = User.find(session[:user_id])
      
      if !@user.menus.exists?(params[:menu_id])
        @user.menus.destroy(params[:menu_id])
        
        render :text => {:status => "success"}.to_json
        return
      end
    end
    render :text => {:status => "invalid"}.to_json
  end
  
  def addnavigation
    if User.loggedIn(session) && !params.values_at(:menu_id, :title).include?(nil)
      @user = User.find(session[:user_id])
      
      languages = Language.find_all_by_locale(params[:title].keys)
      if @user.menus.exists?(params[:menu_id]) && languages.count > 0 && languages.count == params[:title].count
        menu = @user.menus.find(params[:menu_id])
        
        navigation_new = Navigation.create()
        
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
          navigation.sub_navigations.push(navigation_new)
          navigation.save
        else
          navigation_new.level = 0
          menu.navigations.push(navigation_new)
          menu.save
        end
        
        render :text => {:status => "success"}.to_json
        return
      end
    end
    render :text => {:status => "invalid"}.to_json
  end
  
  def editnavigation
    if User.loggedIn(session) && !params.values_at(:navigation_id, :title).include?(nil)
      @user = User.find(session[:user_id])
      
      languages = Language.find_all_by_locale(params[:title].keys)
      #if @user.menus.exists?(params[:menu_id]) && @user.menus.find(params[:menu_id]).navigations.exists?(params[:navigation_id]) && languages.count > 0 && languages.count == params[:title].count
      if Navigation.exists?(params[:navigation_id]) && Navigation.find(params[:navigation_id]).menu.user == @user && languages.count > 0 && languages.count == params[:title].count
        navigation = Navigation.find(params[:navigation_id])
        
        current_locale = I18n.locale
        
        languages.each do |language|
          I18n.locale = language.locale
          navigation.title = params[:title][language.locale]
        end
        navigation.save
        
        I18n.locale = current_locale
        
        #parent = menu
        #parent_navigations = parent.navigations
        #navigation = menu.navigations.find(params[:navigation_id])
        #
        #if params[:sub_navigation_id] == nil || (params[:sub_navigation_id] != nil && navigation.sub_navigations.exists?(params[:sub_navigation_id]))
        #  if params[:sub_navigation_id] != nil && navigation.sub_navigations.exists?(params[:sub_navigation_id])
        #    parent = navigation
        #    parent_navigations = parent.sub_navigations
        #    navigation = parent_navigations.find(params[:sub_navigation_id])
        #  end
        #  
        #  current_locale = I18n.locale
        #  languages.each do |language|
        #    I18n.locale = language.locale
        #    navigation.title = params[:title][language.locale]
        #  end
        #  I18n.locale = current_locale
        #  parent_navigations.push(navigation)
        #  parent.save
        #  
        #  render :text => {:status => "success"}.to_json
        #  return
        #end
      end
    end
    render :text => {:status => "invalid"}.to_json
  end
  
  def sortnavigation
    if User.loggedIn(session) && !params.values_at(:navigation_ids).include?(nil)
      @user = User.find(session[:user_id])
      
      #navigations = nil
      #if params[:menu_id] != nil && @user.menus.exists?(params[:menu_id])
      #  if params[:navigation_id] && @user.menus.find(params[:menu_id]).navigations.exists?(params[:navigation_id])
      #    navigations = @user.menus.find(params[:menu_id]).navigations.find(params[:navigation_id]).sub_navigations
      #  else
      #    navigations = @user.menus.find(params[:menu_id]).navigations
      #  end
      #end
      #
      #if navigations != nil && navigations.count == params[:navigation_ids].count
      #  navigations.each do |navigation|
      #    navigation.position = params[:navigation_ids][navigation.id.to_s]
      #    navigation.save
      #  end
      #end
      
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
        
        current_locale = I18n.locale
        
        languages.each do |language|
          I18n.locale = language.locale
          new_dish.title = params[:title][language.locale]
        end
        
        I18n.locale = current_locale
        
        navigation = Navigation.find(params[:navigation_id])
        navigation.dishes.push(new_dish)
        navigation.save
        
        render :text => {:status => "success"}.to_json
        return
      end
    end
    render :text => {:status => "invalid"}.to_json
  end
  
  def editdish
    if User.loggedIn(session) && !params.values_at(:dish_id, :title).include?(nil)
      @user = User.find(session[:user_id])
      
      languages = Language.find_all_by_locale(params[:title].keys)
      if Navigation.exists?(params[:navigation_id]) && Navigation.find(params[:navigation_id]).menu.user == @user && languages.count > 0 && languages.count == params[:title].count
        #new_dish = Dish.create()
        
        current_locale = I18n.locale
        
        languages.each do |language|
          I18n.locale = language.locale
          new_dish.title = params[:title][language.locale]
        end
        
        I18n.locale = current_locale
        navigation = Navigation.find_by_menu_id_and_id(params[:menu_id],params[:navigation_id])
        navigation.dishes.push(new_dish)
        navigation.save
        
        render :text => {:status => "success"}.to_json
        return
      end
    end
    render :text => {:status => "invalid"}.to_json
  end
  
end
