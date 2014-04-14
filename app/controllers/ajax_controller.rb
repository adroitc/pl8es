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
      
      render :text => {:status => "success", :p => params[:languages]}.to_json.to_s
      return
    end
    render :text => {:status => "invalid"}.to_json
  end
  
  def editmenu
    if User.loggedIn(session) && !params.values_at(:menu_id, :title, :from_time, :to_time, :label).include?(nil)
      @user = User.find(session[:user_id])
      
      menu = @user.menus.find(params[:menu_id])
      if !menu.blank?
      
        if MenuLabel.exists?(params[:label]) || params[:label] != ""
          menuLabel = MenuLabel.find(params[:label])
        else
          menuLabel = nil
        end
      
        menu.attributes = params.permit(:title, :from_time, :to_time).merge({menuLabel: menuLabel})
        menu.save
        
        render :text => {:status => "success"}.to_json.to_s
        return
      end
    end
    render :text => {:status => "invalid"}.to_json
  end
  
  def duplicatemenu
    if User.loggedIn(session) && !params.values_at(:menu_id).include?(nil)
      @user = User.find(session[:user_id])
      
      menu = @user.menus.find(params[:menu_id])
      if !menu.blank?
      
        newMenu = menu.dup
        newMenu.title = newMenu.title+" 2"
        newMenu.save
        
        render :text => {:status => "success"}.to_json.to_s
        return
      end
    end
    render :text => {:status => "invalid"}.to_json
  end
  
  def deletemenu
    if User.loggedIn(session) && !params.values_at(:menu_id).include?(nil)
      @user = User.find(session[:user_id])
      
      if !@user.menus.find(params[:menu_id]).blank?
        @user.menus.destroy(params[:menu_id])
        
        render :text => {:status => "success"}.to_json.to_s
        return
      end
    end
    render :text => {:status => "invalid"}.to_json
  end
  
  def addnavigation
    if User.loggedIn(session) && !params.values_at(:menu_id, :title).include?(nil)
      @user = User.find(session[:user_id])
      
      menu = @user.menus.find(params[:menu_id])
      languages = Language.find_all_by_locale(params[:title].keys)
      if !menu.blank? && languages.count > 0 && languages.count == params[:title].count
        navigation = Navigation.create()
        current_locale = I18n.locale
        languages.each do |language|
          I18n.locale = language.locale
          navigation.title = params[:title][language.locale]
        end
        I18n.locale = current_locale
        menu.navigations.push(navigation)
        menu.save
        render :text => {:status => "success"}.to_json.to_s
        return
      end
    end
    render :text => {:status => "invalid"}.to_json
  end
  
  def editnavigation
    if User.loggedIn(session) && !params.values_at(:menu_id, :navigation_id, :title).include?(nil)
      @user = User.find(session[:user_id])
      
      menu = @user.menus.find(params[:menu_id])
      languages = Language.find_all_by_locale(params[:title].keys)
      if !menu.blank? && menu.navigations.exists?(params[:navigation_id]) && languages.count > 0 && languages.count == params[:title].count
        navigation = menu.navigations.find(params[:navigation_id])
        current_locale = I18n.locale
        languages.each do |language|
          I18n.locale = language.locale
          navigation.title = params[:title][language.locale]
        end
        I18n.locale = current_locale
        menu.navigations.push(navigation)
        menu.save
        render :text => {:status => "success"}.to_json.to_s
        return
      end
    end
    render :text => {:status => "invalid"}.to_json
  end
  
end
