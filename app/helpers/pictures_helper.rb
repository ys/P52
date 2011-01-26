module PicturesHelper
  
  def user_owns_picture? picture
    if user_signed_in?
      if current_user == picture.user
        return true
      end
      
    end
    return false
  end
end
