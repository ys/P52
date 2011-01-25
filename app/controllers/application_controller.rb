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
end
