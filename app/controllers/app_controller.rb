class AppController < ApplicationController
  
  def menumalist
    if User.find_by_download_code(params[:user_download_code])
      app_user = User.find_by_download_code(params[:user_download_code])
      #json = JSON.parse(
      #  ipull_user.to_json(
      #    :only => [:app_title],
      #    :include => {
      #      :menuStyle => {
      #        :only => [:background_color, :text_color, :line_color],
      #        :include => {
      #          :menuButton  => {
      #            :only => [:image]
      #          },
      #          :menuType  => {
      #            :only => [:image]
      #          }
      #        }
      #      },
      #      :navigationStyle => {
      #        :only => [:background_color, :text_color, :button_color, :statusbar_color],
      #        :include => {
      #          :navigationButton  => {
      #            :only => [:image]
      #          },
      #          :navigationColorTemplate => {
      #            :only => [:background_color, :button_color, :statusbar_color, :text_color]
      #          }
      #        }
      #      }
      #    }
      #  )
      #)
      render :json => {
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
                :only => [:id, :title, :image_fingerprint],
                :methods => [:image_url, :navigation_lang],
                :include => {
                  :sub_navigations => {
                    :only => [:id, :title, :image_fingerprint],
                    :methods => [:image_url, :navigation_lang],
                    :include => {
                      :dishes => {
                        :only => [:id, :title, :image_fingerprint],
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
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
