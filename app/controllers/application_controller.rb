class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :set_current_locale
  
  #helper_method :url_for
  #def url_for(options = {}, *params)
  #  
  #  subdomain = Rails.application.routes.routes.routes.find_all{|item|
  #    item.requirements[:controller] == options[:controller] &&
  #    item.requirements[:action] == options[:action]
  #  }[0].constraints[:subdomain]
  #  
  #  if subdomain
  #    options[:only_path] = false
  #    options[:subdomain] = subdomain
  #  end
  #    
  #  return super(options, *params)
  #end
  #
  #helper_method :redirect_to
  #def redirect_to(options = {}, *params)
  #  
  #  subdomain = Rails.application.routes.routes.routes.find_all{|item|
  #    item.requirements[:controller] == options[:controller] &&
  #    item.requirements[:action] == options[:action]
  #  }[0].constraints[:subdomain]
  #  
  #  if subdomain
  #    options[:only_path] = false
  #    options[:subdomain] = subdomain
  #  end
  #    
  #  return super(options, *params)
  #end

  private
  def set_current_locale
    #device
    if Device.validHeader(@_headers)
      if Device.exists?(:device_id => header["Device-Id"])
        @device = Device.find_by_device_id(@_headers["Device-Id"])
        @device.update_attributes({
          :device_app => @_headers["Device-App"],
          :device_version => @_headers["Device-Version"],
          :device_type => @_headers["Device-Type"],
          :device_system => @_headers["Device-System"]
        })
        @device.touch
      else
        @device = Device.create({
          :device_id => @_headers["Device-Id"],
          :device_app => @_headers["Device-App"],
          :device_version => @_headers["Device-Version"],
          :device_type => @_headers["Device-Type"],
          :device_system => @_headers["Device-System"]
        })
      end
    end
    
    #user
    if User.loggedIn(session)
      @user = User.find(session[:user_id])
    end
    
    #session + request
    if Session.logsSession(session, @_headers)
      @session = Session.find(session[:user_session_id])
    elsif @user || @device
      @session = Session.create({
        :user => @user,
        :device => @device
      })
      session[:user_session_id] = @session.id
    end
    Request.create(params.permit(:controller, :action).merge({
      :session => @session,
      :params => params.to_json({
        :except => [
          :controller,
          :action,
          :password
        ]
      })
    }))
    
    #language
    if params[:locale]
      I18n.locale = params[:locale]
    end
  end
  
end
