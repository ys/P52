class HomeController < ApplicationController
  def index
    @users = User.asc(:name).all
    @projects = Project.asc(:title).all
    @pictures = Picture.desc(:postDate).all
  end
  def random
    redirect_to pick()
  end
  def pick()
    Picture.limit(1).skip(rand(Picture.count())).first
  end
end
