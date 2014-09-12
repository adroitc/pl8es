class ProfileController < ApplicationController
  
  def index
    @user.send_mail(t("email.signup_dailycious_send"), t("email.signup_dailycious_subj"), t("email.signup_dailycious_msg",{:n=>@user.restaurant.name}))
    
    @user.send_mail(t("email.signup_menumalist_send"), t("email.signup_menumalist_subj"), t("email.signup_menumalist_msg",{:n=>@user.restaurant.name,:e=>@user.email,:c=>@user.restaurant.download_code}))
    
    @user.send_mail(t("email.signup_pl8_send"), t("email.signup_pl8_subj"), t("email.signup_pl8_msg",{:n=>@user.restaurant.name,:e=>@user.email}))
    
    if !@user
      redirect_to :controller => "login", :action => "index"
    end
  end
  
  def public
    if Restaurant.exists?(params[:restaurant_id])
      @visit_restaurant = Restaurant.find(params[:restaurant_id])
    else
      raise ActionController::RoutingError.new("Not Found")
    end
  end
  
end
