class Ajax::ProfileController < ApplicationController
  
  def editsettings
    if User.loggedIn(session) && !params.values_at(:default_language, :email, :address, :zip, :city, :country).include?(nil)
      @user = User.find(session[:user_id])
      
      @user.attributes = params.permit(:email, :address, :zip, :city, :country, :website, :telephone)
      
      if Language.exists?(params[:default_language])
        @user.default_language = Language.find(params[:default_language])
      end
      
      @user.save
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
  def editdescription
    if User.loggedIn(session) && !params.values_at(:name, :description).include?(nil)
      @user = User.find(session[:user_id])
      
      @user.attributes = params.permit(:logo_image, :restaurant_image, :name)
      
      languages = Language.find_all_by_locale(params[:description].keys)
      
      current_locale = I18n.locale
      
      languages.each do |language|
        I18n.locale = language.locale
        @user.description = params[:description][language.locale]
      end
      
      I18n.locale = current_locale
      
      if params[:logo_image]
        if @user.logo_image_dimensions["original"][1] >= @user.logo_image_dimensions["original"][0]
          @user.logo_image_crop_w = @user.logo_image_dimensions["original"].min
          @user.logo_image_crop_h = @user.logo_image_crop_w/(@user.logo_image_dimensions["cropped_default_retina"][0].to_f/@user.logo_image_dimensions["cropped_default_retina"][1].to_f)
        else
          @user.logo_image_crop_h = @user.logo_image_dimensions["original"].min
          @user.logo_image_crop_w = (@user.logo_image_dimensions["cropped_default_retina"][0].to_f/@user.logo_image_dimensions["cropped_default_retina"][1].to_f)*@user.logo_image_crop_h
        end
        @user.logo_image_crop_x = (@user.logo_image_dimensions["original"][0]-@user.logo_image_crop_w).to_f/2
        @user.logo_image_crop_y = (@user.logo_image_dimensions["original"][1]-@user.logo_image_crop_h).to_f/2
      elsif !params.values_at(:logo_image_crop_w, :logo_image_crop_h, :logo_image_crop_x, :logo_image_crop_y).include?(nil)
        if params[:logo_image_crop_w].to_i+params[:logo_image_crop_x].to_i > @user.logo_image_dimensions["original"][0]
          params[:logo_image_crop_x] = @user.logo_image_dimensions["original"][0]-params[:logo_image_crop_w].to_i
        end
        if params[:logo_image_crop_h].to_i+params[:logo_image_crop_y].to_i > @user.logo_image_dimensions["original"][1]
          params[:logo_image_crop_y] = @user.logo_image_dimensions["original"][1]-params[:logo_image_crop_h].to_i
        end
        
        @user.attributes = params.permit(:logo_image_crop_w, :logo_image_crop_h, :logo_image_crop_x, :logo_image_crop_y)
        if @user.logo_image_crop_w_changed? || @user.logo_image_crop_h_changed? || @user.logo_image_crop_x_changed? || @user.logo_image_crop_y_changed?
          @user.save
          @user.update_attributes({:logo_image_crop_processed => false})
          @user.logo_image.reprocess!
          @user.update_attributes({:logo_image_crop_processed => true})
        else
        end
      end
      
      if params[:restaurant_image]
        if @user.restaurant_image_dimensions["original"][1] >= @user.restaurant_image_dimensions["original"][0]
          @user.restaurant_image_crop_w = @user.restaurant_image_dimensions["original"].min
          @user.restaurant_image_crop_h = @user.restaurant_image_crop_w/(@user.restaurant_image_dimensions["cropped_default_retina"][0].to_f/@user.restaurant_image_dimensions["cropped_default_retina"][1].to_f)
        else
          @user.restaurant_image_crop_h = @user.restaurant_image_dimensions["original"].min
          @user.restaurant_image_crop_w = (@user.restaurant_image_dimensions["cropped_default_retina"][0].to_f/@user.restaurant_image_dimensions["cropped_default_retina"][1].to_f)*@user.restaurant_image_crop_h
        end
        @user.restaurant_image_crop_x = (@user.restaurant_image_dimensions["original"][0]-@user.restaurant_image_crop_w).to_f/2
        @user.restaurant_image_crop_y = (@user.restaurant_image_dimensions["original"][1]-@user.restaurant_image_crop_h).to_f/2
      elsif !params.values_at(:restaurant_image_crop_w, :restaurant_image_crop_h, :restaurant_image_crop_x, :restaurant_image_crop_y).include?(nil)
        if params[:restaurant_image_crop_w].to_i+params[:restaurant_image_crop_x].to_i > @user.restaurant_image_dimensions["original"][0]
          params[:restaurant_image_crop_x] = @user.restaurant_image_dimensions["original"][0]-params[:restaurant_image_crop_w].to_i
        end
        if params[:restaurant_image_crop_h].to_i+params[:restaurant_image_crop_y].to_i > @user.restaurant_image_dimensions["original"][1]
          params[:restaurant_image_crop_y] = @user.restaurant_image_dimensions["original"][1]-params[:restaurant_image_crop_h].to_i
        end
        
        @user.attributes = params.permit(:restaurant_image_crop_w, :restaurant_image_crop_h, :restaurant_image_crop_x, :restaurant_image_crop_y)
        if @user.restaurant_image_crop_w_changed? || @user.restaurant_image_crop_h_changed? || @user.restaurant_image_crop_x_changed? || @user.restaurant_image_crop_y_changed?
          @user.save
          @user.update_attributes({:restaurant_image_crop_processed => false})
          @user.logo_image.reprocess!
          @user.update_attributes({:restaurant_image_crop_processed => true})
        else
        end
      end
      
      @user.save
      
      render :json => {:status => "success"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
