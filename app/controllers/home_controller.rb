class HomeController < ApplicationController
  def index
    @users = User.all
    @projects = Project.all
    @pictures = Picture.all
  end

end
