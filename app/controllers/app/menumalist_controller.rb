class App::MenumalistController < ApplicationController
  
  def index
    client = Client.validHeader(request.headers)
    if client && Restaurant.find_by_download_code(params[:user_download_code])
      @req_restaurant = Restaurant.find_by_download_code(params[:user_download_code])
      
      request_partial = render_to_string(
        :partial => "menumalist"
      )
      request_hash = Digest::SHA2.hexdigest(request_partial)
      
      if client.request_hash != request_hash
        client.update_attributes({
          :restaurant => @req_restaurant,
          :request_hash => request_hash
        })
      else
        render :json => {:status => "uptodate"}
        return
      end
      
      render :json => request_partial
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
