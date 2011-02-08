module ProjectsHelper
  def validProjectSizes
    [365,52,12]
  end
  
  def user_owns_project? project
    if user_signed_in?
      if current_user == project.user
        return true
      end
      
    end
    return false
  end
  
  
  
end
