class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :set_current_locale
  
  helper_method :url_for
  def url_for(options = {}, *params)
    
    subdomain = Rails.application.routes.routes.routes.find_all{|item|
      item.requirements[:controller] == options[:controller] &&
      item.requirements[:action] == options[:action]
    }[0].constraints[:subdomain]
    
    if subdomain
      options[:only_path] = false
      options[:subdomain] = subdomain
    end
      
    return super(options, *params)
  end
  
  helper_method :redirect_to
  def redirect_to(options = {}, *params)
    
    subdomain = Rails.application.routes.routes.routes.find_all{|item|
      item.requirements[:controller] == options[:controller] &&
      item.requirements[:action] == options[:action]
    }[0].constraints[:subdomain]
    
    if subdomain
      options[:only_path] = false
      options[:subdomain] = subdomain
    end
      
    return super(options, *params)
  end

  private
  def set_current_locale
    I18n.locale = params[:locale]
  end
  
end
