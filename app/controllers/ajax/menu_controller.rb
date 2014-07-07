class Ajax::MenuController < ApplicationController
  
  def addmenu
    if @user && !params.values_at(:title, :from_time, :to_time, :default_language).include?(nil) && Language.exists?(params[:default_language].to_i)
      languages = Array.new
      if params[:languages]
        params[:languages].each do |language|
          if Language.exists?(language[0].to_i)
            languages.push(Language.find(language[0].to_i))
          end
        end
      end
      if !languages.include?(Language.find(params[:default_language].to_i))
        languages.push(Language.find(params[:default_language].to_i))
      end
      
      new_menu = Menu.create(params.permit(:title, :from_time, :to_time).merge({
        :default_language => Language.find(params[:default_language].to_i),
        :languages => languages,
        :user => @user
      }))
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid", :params => params}
  end
  
  def editmenu
    if @user && !params.values_at(:menu_id, :title, :from_time, :to_time, :default_language).include?(nil) && @user.menus.exists?(params[:menu_id]) && Language.exists?(params[:default_language].to_i)
      menu = @user.menus.find(params[:menu_id])
      
      if params[:delete] == "true"
        menu.destroy
      else
        languages = Array.new
        if params[:languages]
          params[:languages].each do |language|
            if Language.exists?(language[0].to_i)
              languages.push(Language.find(language[0].to_i))
            end
          end
        end
        if !languages.include?(Language.find(params[:default_language].to_i))
          languages.push(Language.find(params[:default_language].to_i))
        end
        
        menu.update_attributes(params.permit(:title, :from_time, :to_time).merge({
          :default_language => Language.find(params[:default_language].to_i),
          :languages => languages
        }))
      end
      
      render :json => {:status => "success", :p => params}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def duplicatemenu
    if @user && !params.values_at(:menu_id).include?(nil) && @user.menus.exists?(params[:menu_id])
      menu = @user.menus.find(params[:menu_id])
      
      dup_menu = menu.dup
      dup_menu.title = menu.title+" 2"
      dup_menu.save
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
