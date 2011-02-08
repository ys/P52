class HomeController < ApplicationController
  def index
    @users = User.desc(:last_sign_in_at).limit(20)
    @projects = Project.desc(:updated_at).limit(20)
    @pictures = Picture.desc(:postDate).paginate :page => params[:page], :per_page => per_page
  end
  def random
    redirect_to pick()
  end
  def pick()
    Picture.limit(1).skip(rand(Picture.count())).first
  end
end
