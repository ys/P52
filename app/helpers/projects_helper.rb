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
  
  def new_picture_needed_for_period size
    case size
    when 12
      'month'
    when 52
      'week'
    when 365
      'two days'
    else false
    end
 
  end
  
end
