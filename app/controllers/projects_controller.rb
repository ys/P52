class ProjectsController < ApplicationController

  before_filter :authenticate_user! ,:except =>[:show, :index, :globalIndex, :feed]
  #before_filter :must_be_auth_with_flickr! , :only => [:new,:archive,:edit,:create, :update, :destroy, :admin]
  before_filter :preload_user , :only =>[:show, :index, :feed]
  before_filter :current_user_load, :only =>[:archive,:edit,:create, :update, :destroy, :admin]
  before_filter :preload_project, :only => [:archive,:show, :edit, :update, :destroy, :feed]
  before_filter :user_owns_project! ,:only => [:edit, :update, :destroy]
  before_filter :preload_projects , :only => [:index, :admin]
  def user_owns_project!
    if authenticate_user!
      unless current_user == @project.user
        flash[:alert] = "You're not the right user!"
        redirect_to root_url
      end
    end
  end

  def preload_project
    project_title = params[:id] || params[:project_id]
    @project = Project.asc(:title).where(:user_id => @user.id, :title =>project_title).first
  end

  def preload_projects
    @projects = Project.desc(:updated_at).where(:user_id => @user.id).paginate :page => params[:page], :per_page => per_page
  end
  def globalIndex
    add_crumb 'Projects', projects_path
    @projects = Project.desc(:updated_at).paginate :page => params[:page], :per_page => per_page
    render "index"
  end

  # GET /projects
  # GET /projects.xml
  def index
    add_crumb 'Users', users_path
    add_crumb @user.name, user_path(@user)
    add_crumb 'Projects', user_projects_path(@user)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    add_crumb 'Users', users_path
    add_crumb @user.name, user_path(@user)
    add_crumb 'Projects', user_projects_path(@user)
    add_crumb @project.title, user_project_path(@user,@project)
    @pictures = Picture.where(:project_id => @project.id).paginate :page => params[:page], :per_page => per_page
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project }
      format.json  { render :json => {:project => @project, :pictures => @pictures} }
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
    @project.size = params[:project][:size]
    @project.user = current_user
    @project.endingDate = Time.now + @project.size.days if @project.size
    @project.current = true
    @project.closed = false

    respond_to do |format|
      if !current_user.can_have_project? @project.size
        format.html { redirect_to(user_projects_url(current_user), :alert => 'YOU ALREADY HAVE THAT KIND OF PROJECT') }
        format.xml  { head :forbidden}
      else
        if @project.save
          format.html { redirect_to([@project.user, @project], :alert => 'Project was successfully created.') }
          format.xml  { render :xml => @project, :status => :created, :location => @project }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
        end
      end

    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to([@project.user, @project], :notice => 'Project was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def archive
    @project.closed = true
    @project.current = false
    respond_to do |format|
      if @project.save
        format.html { redirect_to([@project.user, @project], :notice => 'Project was successfully archived.') }
        format.xml  { head :ok }
      else
        format.html { redirect_to([@project.user, @project], :alert => 'Project was not archived.') }
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
  
  def admin 
  end
  
  def feed
    respond_to do |format|
      format.atom
    end
  end
  
  
end
