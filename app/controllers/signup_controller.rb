class SignupController < ApplicationController
  
  def index
    if User.loggedIn(session)
      redirect_to :controller => "menumalist", :action => "index"
    end
    #ses = AWS::SES::Base.new(
    #  :access_key_id     => ENV['AWS_ACCESS'],
    #  :secret_access_key => ENV['AWS_SECRET']
    #)
    #ses.send_email(
    #  :to         => ["hello@malist.co"],
    #  :source     => "hello@malist.co",
    #  :subject    => "test message",
    #  :text_body  => "test message"
    #)
    #render :text => ses.addresses.list.result
  end
  
end
