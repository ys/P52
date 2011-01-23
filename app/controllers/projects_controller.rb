class ProjectsController < ApplicationController
  
  before_filter :authenticate_user! ,:except =>[:show, :index, :globalIndex]
  before_filter :preload_user , :only =>[:show, :index]
  before_filter :current_user_load, :only =>[:edit,:create, :update, :destroy]
  before_filter :preload_project, :only => [:show, :edit, :update, :destroy]
  before_filter :user_owns_project! ,:only => [:edit, :update, :destroy]
  
  def user_owns_project!
    if authenticate_user!
      unless current_user == @project.user
        flash[:alert] = "You're not the right user!"
        redirect_to root_url
      end
    end
  end
  def preload_user
    @user = User.find(:first,:conditions =>{:name=>params[:user_id]})
  end
  def current_user_load
    @user = current_user
  end
  def preload_project
    @project = Project.find(:first, :conditions =>{:user_id => @user.id, :title =>params[:id]})
  end
  
  
  def globalIndex
    @projects = Project.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end
  
  # GET /projects
  # GET /projects.xml
  def index
    @projects = Project.find(:conditions =>{:user_id => @user.id})
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
    
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])
    @project.user = current_user
    respond_to do |format|
      if @project.save
        format.html { redirect_to(@project, :notice => 'Project was successfully created.') }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to(@project, :notice => 'Project was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end
end
