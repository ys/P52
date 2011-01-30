class HomeController < ApplicationController
  def index
    @users = User.asc(:name).all
    @projects = Project.asc(:title).all
    @pictures = Picture.desc(:postDate).all
  end

end
