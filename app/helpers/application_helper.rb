module ApplicationHelper
  
  def user_owns? object
    if user_signed_in?
      if current_user == object.user
        return true
      end
      
    end
    return false
  end
  
  def image_url(source)
      abs_path = image_path(source)
      unless abs_path =~ /^http/
        abs_path = "#{request.protocol}#{request.host_with_port}#{abs_path}"
      end
     abs_path
  end
end
