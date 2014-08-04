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
    #user
    if User.loggedIn(session)
      @user = User.find(session[:user_id])
    elsif request.headers["Token"] && !Session.find_by_token(request.headers["Token"]).blank?
      @user = Session.find_by_token(request.headers["Token"]).user
    end
    
    #device
    if Device.validHeader(request.headers)
      if Device.exists?(:device_id => request.headers["Device-Id"])
        @device = Device.find_by_device_id(request.headers["Device-Id"])
        @device.update_attributes({
          :user => @user,
          :device_app => request.headers["Device-App"],
          :device_version => request.headers["Device-Version"],
          :device_type => request.headers["Device-Type"],
          :device_system => request.headers["Device-System"]
        })
        @device.touch
      else
        @device = Device.create({
          :user => @user,
          :device_id => request.headers["Device-Id"],
          :device_app => request.headers["Device-App"],
          :device_version => request.headers["Device-Version"],
          :device_type => request.headers["Device-Type"],
          :device_system => request.headers["Device-System"]
        })
      end
    end
    
    #session + request
    if Session.logsSession(session, request.headers)
      @session = Session.find(session[:user_session_id])
    elsif @user || @device
      token = SecureRandom.hex(32).upcase
      while Session.find_by_token(token).present?
        token = SecureRandom.hex(32).upcase
      end
      @session = Session.create({
        :user => @user != nil ? @user : @device.user,
        :device => @device,
        :token => token
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
