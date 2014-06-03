class Ajax::MenuController < ApplicationController
  
  def addmenu
    if User.loggedIn(session) && !params.values_at(:title, :from_time, :to_time, :default_language).include?(nil)
      @user = User.find(session[:user_id])
      
      menu = Menu.create(params.permit(:title, :from_time, :to_time))
      
      if Language.exists?(params[:default_language].to_i)
        menu.default_language = Language.find(params[:default_language].to_i)
      end
      
      languages = Array.new
      if params[:languages]
        params[:languages].each do |language|
            if Language.exists?(language[0].to_i)
              languages.push(Language.find(language[0].to_i))
          end
        end
      end
      if Language.exists?(params[:default_language].to_i) && !languages.include?(Language.find(params[:default_language].to_i))
        languages.push(Language.find(params[:default_language].to_i))
      end
      menu.languages = languages
      
      if MenuLabel.exists?(params[:label]) || (params[:label] && params[:label] != "")
        menuLabel = MenuLabel.find(params[:label])
      else
        menuLabel = nil
      end
      menu.menuLabel = menuLabel
      
      menu.save
      
      @user.menus.push(menu)
      @user.save
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def editmenu
    if User.loggedIn(session) && !params.values_at(:menu_id, :title, :from_time, :to_time, :default_language).include?(nil)
      @user = User.find(session[:user_id])
      
      if @user.menus.exists?(params[:menu_id])
        menu = @user.menus.find(params[:menu_id])
        
        if Language.exists?(params[:default_language].to_i)
          menu.default_language = Language.find(params[:default_language].to_i)
        end
        
        languages = Array.new
        if params[:languages]
          params[:languages].each do |language|
            if Language.exists?(language[0].to_i)
              languages.push(Language.find(language[0].to_i))
            end
          end
        end
        if Language.exists?(params[:default_language].to_i) && !languages.include?(Language.find(params[:default_language].to_i))
          languages.push(Language.find(params[:default_language].to_i))
        end
        menu.languages = languages
        
        if MenuLabel.exists?(params[:label]) || params[:label] != ""
          menuLabel = MenuLabel.find(params[:label])
        else
          menuLabel = nil
        end
      
        menu.attributes = params.permit(:title, :from_time, :to_time).merge({languages: languages, menuLabel: menuLabel})
        menu.save
        
        render :json => {:status => "success"}
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
  
end
