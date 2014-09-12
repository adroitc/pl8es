class App::MenumalistController < ApplicationController
  
  def index
    client = Client.validHeader(request.headers)
    if client && Restaurant.find_by_download_code(params[:user_download_code])
      @req_restaurant = Restaurant.find_by_download_code(params[:user_download_code])
      
      if client.restaurant == @req_restaurant || @req_restaurant.clients.actives.count < 1
        request_partial = render_to_string(
          :partial => "menumalist"
        )
        request_hash = Digest::SHA2.hexdigest(request_partial)
        
        if client.request_hash != request_hash
          client.update_attributes({
            :restaurant => @req_restaurant,
            :request_hash => request_hash
          })
        
          render :json => request_partial
          return
        end
        render :json => {:status => "uptodate"}
        return
      end
      render :json => {:status => "reachedmax"}
      return
    end
    render :json => {:status => "invalid"}
  end
  
end
