class SignupController < ApplicationController
  
  def index
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
  
  def index_post
    if !params.values_at(:name, :email, :password).include?(nil)
      @user = User.create(params.permit(:name, :email, :password))
      
      if @user.errors.count == 0 && !@user.blank?
        
        
        render :text => {:signup_status => "success"}.to_json.to_s
        return
      end
    end
    render :text => {:signup_status => "invalid"}.to_json.to_s
  end
  
end
