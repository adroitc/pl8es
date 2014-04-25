class AppController < ApplicationController
  
  def menumalist
    if User.find_by_download_code(params[:user_download_code])
      app_user = User.find_by_download_code(params[:user_download_code])
      return_json = {
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
                :only => [:id, :image_fingerprint],
                :methods => [:image_url, :navigation_lang],
                :include => {
                  :dishes => {
                    :only => [:id, :image_fingerprint],
                    :methods => [:image_url, :dish_lang]
                  },
                  :sub_navigations => {
                    :only => [:id, :image_fingerprint],
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
        )
      }
      #render :text => Digest::SHA1.hexdigest(return_json.to_json.to_s)
      render :json => return_json
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
