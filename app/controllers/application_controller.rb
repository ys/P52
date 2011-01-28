class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def preload_user
    @user = if (params[:user_id])
      User.find(:first,:conditions =>{:name=>params[:user_id]})
    else
      User.find(:first,:conditions =>{:name=>params[:id]})
    end
  end
  def current_user_load
    @user = current_user
  end
  def must_be_auth_with_flickr!
    if !current_user.authenticated_to_flickr?
      redirect_to(authentications_url, :notice => 'YOU MUST AUTHENTICATE TO FLICKR TO POST!')
    end
  end
end
