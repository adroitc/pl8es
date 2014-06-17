class AppController < ApplicationController
  
  def menumalist
    if User.find_by_download_code(params[:user_download_code]) && request.headers["Device-Id"] && request.headers["Device-App"] && request.headers["Device-Version"] && request.headers["Device-Type"] && request.headers["Device-System"]
      @req_user = User.find_by_download_code(params[:user_download_code])
      
      request_partial = render_to_string(
        :partial => "menumalist"
      )
      request_hash = Digest::SHA2.hexdigest(request_partial)
      
      if Device.exists?(:device_id => request.headers["Device-Id"])
        device = Device.find_by_device_id(request.headers["Device-Id"])
        device.update_attributes({
          :device_app => request.headers["Device-App"],
          :device_version => request.headers["Device-Version"],
          :device_type => request.headers["Device-Type"],
          :device_system => request.headers["Device-System"]
        })
        if device.request_hash != request_hash
          device.update_attributes({
            :request_hash => request_hash
          })
        else
          render :json => {:status => "uptodate"}
          return
        end
      else
        Device.create([{
          :user => @req_user,
          :device_id => request.headers["Device-Id"],
          :device_app => request.headers["Device-App"],
          :device_version => request.headers["Device-Version"],
          :device_type => request.headers["Device-Type"],
          :device_system => request.headers["Device-System"],
          :request_hash => request_hash
        }])
      end
      
      render :json => request_partial
      return
    elsif User.find_by_download_code(params[:user_download_code])
      @req_user = User.find_by_download_code(params[:user_download_code])
      
      render :partial => "menumalist"
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
