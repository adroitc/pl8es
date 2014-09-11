class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :set_current_locale

  private
  def set_current_locale
    
    #user
    if User.loggedIn(session)
      @user = User.find(session[:user_id])
    end
    
    #session + request
    if Session.logsSession(session)
      @session = Session.find(session[:user_session_id])
      if !@user && @session.user
        @user = @session.user
      end
    elsif request.headers["Token"] && !Session.find_by_token(request.headers["Token"]).blank?
      @session = Session.find_by_token(request.headers["Token"])
      if !@user && @session.user
        @user = @session.user
      end
      session[:user_session_id] = @session.id
    else
      token = SecureRandom.hex(32).upcase
      while Session.find_by_token(token).present?
        token = SecureRandom.hex(32).upcase
      end
      @session = Session.create({
        :device => @device,
        :token => token,
        :user_agent => request.env["HTTP_USER_AGENT"]
      })
      session[:user_session_id] = @session.id
    end
    if params[:controller] == "app/dailycious" && params[:action] == "map"
      #no log
    else
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
    end
    @session.touch

    #device
    if Device.validHeader(request.headers)
      device_content = {
        :user => @user,
        :device_id => request.headers["Device-Id"],
        :device_app => request.headers["Device-App"],
        :device_version => request.headers["Device-Version"],
        :device_type => request.headers["Device-Type"],
        :device_system => request.headers["Device-System"]
      }
      if Device.exists?(:device_id => request.headers["Device-Id"])
        @device = Device.find_by_device_id(request.headers["Device-Id"])
      else
        @device = Device.create()
      end
      @device.update_attributes(device_content)
      if @session
        @session.update_attributes({
          :user => @user,
          :device => @device
        })
      end
      @device.touch
    end
    
    #language
    if params[:locale]
      I18n.locale = params[:locale]
      if @user && Language.exists?(:locale => params[:locale])
        @user.restaurant.update_attributes(:default_language => Language.find(:locale => params[:locale]))
      end
      if session[:signup]
        session[:signup][:locale] = params[:locale]
      end
    elsif !@user && extract_locale_from_accept_language_header
      I18n.locale = extract_locale_from_accept_language_header
      if session[:signup]
        session[:signup][:locale] = extract_locale_from_accept_language_header
      end
    elsif @user
      I18n.locale = @user.restaurant.default_language.locale
    end
  end
  
  private
  
  def extract_locale_from_accept_language_header
    if request.env['HTTP_ACCEPT_LANGUAGE']
      return request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    end
    nil
  end
  
end
