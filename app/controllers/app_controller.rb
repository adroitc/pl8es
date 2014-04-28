class AppController < ApplicationController
  
  def menumalist
    if User.find_by_download_code(params[:user_download_code])
      app_user = User.find_by_download_code(params[:user_download_code])
      return_json = {
        :content_restaurant => JSON.parse(
          app_user.to_json(
            :only => [:name, :address, :zip, :city, :country, :appmain_image_fingerprint],
            :methods => [:appmain_image_url]
          )
        ),
        :content_menues => JSON.parse(
          app_user.menus.to_json(
            :only => [:title, :from_time, :to_time],
            :include => {
              :default_language => {
                :only => [:locale, :title]
              },
              :languages => {
                :only => [:locale, :title]
              },
              :navigations => {
                :only => [:id, :image_fingerprint, :style],
                :methods => [:image_url, :navigation_lang],
                :include => {
                  :dishes => {
                    :only => [:id, :image_fingerprint],
                    :methods => [:image_url, :dish_lang]
                  },
                  :sub_navigations => {
                    :only => [:id, :image_fingerprint, :style],
                    :methods => [:image_url, :navigation_lang],
                    :include => {
                      :dishes => {
                        :only => [:id, :image_fingerprint],
                        :methods => [:image_url, :dish_lang]
                      }
                    }
                  }
                }
              }
            }
          )
        ),
        :content_style => JSON.parse(
          app_user.menuColor.to_json(
            :only => [:background, :bar_background, :bev_background, :bev_background_selected, :bev_background_active, :bev_text, :bev_text_selected, :bev_text_active, :nav_background, :nav_background_selected, :nav_background_active, :nav_text, :nav_text_selected, :nav_text_active, :sub_background, :sub_background_selected, :sub_background_active, :sub_text, :sub_text_selected, :sub_text_active]
          )
        )
      }
      #render :text => Digest::SHA1.hexdigest(return_json.to_json.to_s)
      render :json => return_json
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
