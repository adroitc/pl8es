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
    if User.loggedIn(session) && !params.values_at(:title, :from_time, :to_time, :label).include?(nil)
      @user = User.find(session[:user_id])
      
      if MenuLabel.exists?(params[:label]) || params[:label] != ""
        menuLabel = MenuLabel.find(params[:label])
      else
        menuLabel = nil
      end
      
      menu = Menu.create(params.permit(:title, :from_time, :to_time).merge({menuLabel: menuLabel}))
      @user.menus.push(menu)
      @user.save
      
      render :text => {:status => "success"}.to_json.to_s
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
      
      menu = @user.menus.find(params[:menu_id])
      if !menu.blank?
      
        @user.menus.destroy(params[:menu_id])
        
        render :text => {:status => "success"}.to_json.to_s
        return
      end
    end
    render :text => {:status => "invalid"}.to_json
  end
  
end
