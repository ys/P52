class PicturesController < ApplicationController
  before_filter :authenticate_user! ,:except =>[:show, :index, :globalIndex]
  #before_filter :must_be_auth_with_flickr! , :only => [:new,:archive,:edit,:create, :update, :destroy, :admin]
  before_filter :preload_user, :only =>[:show,:index]
  before_filter :current_user_load, :only =>[:new,:edit,:create, :update, :destroy, :admin]

  before_filter :must_have_active_project! , :only=>[:new,:create,:update,:edit, :destroy]

  before_filter :preload_picture!, :except=>[:globalIndex, :new,:index,:create, :admin]
  before_filter :load_flickraw, :only=>[:create, :new, :edit, :update]
  before_filter :preload_new_edit, :only=>[:new, :create]
  before_filter :charge_image_from_params , :only => [:create]
  before_filter :verify_image! , :only=>[:create]
  before_filter :preload_pictures, :only=>[:index, :admin]
  require "kconv"
  def preload_new_edit

      #@pictures = flickr.photos.search(:user_id => 'me')
      @project = Project.find(:first, :conditions => {:title =>params[:project_id], :user_id =>@user.id}) if (params[:project_id])
      @projects = Project.find(:conditions => {:user_id => @user.id})
      back_to = 32
      back_to = (365/@project.size)+1 if @project

      @pictures = flickr.photos.search(:user_id => 'me', :min_upload_date => (Time.now-back_to.day).to_i , :max_upload_date => Time.now.to_i ) if @auth1

  end

  def preload_picture!
    @picture = Picture.find(params[:id])
    if(params[:user_id] && !(@user.pictures.include? @picture))
      redirect_to @picture
    end

  end
  def load_flickraw
    FlickRaw.api_key='52c9226e6d1e5c2452366c0f26e5ee11'
    FlickRaw.shared_secret='7248d7d35fd2b1d5'
    @auth = @user.authentications.find(:first, :conditions => { :provider => 'flickr' })

    @auth1 = flickr.auth.checkToken(:auth_token => @auth['token']) if @auth
  end

  def must_have_active_project!
    projects = Project.where(:user_id => current_user.id, :closed => false, :current => true).all
    if projects.empty?
      #false
      redirect_to new_project_path
    else
      #true
    end
  end

  def charge_image_from_params
    @picture = Picture.new(params[:picture])
  end

  def verify_image!
    if !@picture.project.can_post_picture?
      format.html { redirect_to([current_user,@picture.project], :notice => 'THIS PROJECT DOES NOT ACCEPT ANY NEW PICTURES') }
      format.xml  { head :forbidden}
    elsif !@picture.project.can_have_new_picture?
      format.html { redirect_to([current_user,@picture.project], :notice => 'YOU ALREADY POSTED ONE PICTURE FOR THIS PROJECT DURING THE CURRENT PERIOD') }
      format.xml  { head :forbidden}
    end

  end

  def preload_pictures
    projects = Project.where(:user_id => @user.id).map(&:_id)
    @pictures = Picture.desc(:postDate).where(:project_id.in => projects).desc(:postDate).paginate :page => params[:page], :per_page => per_page
    
  end

  def globalIndex
    add_crumb 'Pictures', pictures_path
    @pictures = Picture.desc(:postDate).paginate :page => params[:page], :per_page => per_page 
    render :index
  end

  # GET /pictures
  # GET /pictures.xml
  def index
    add_crumb 'Users', users_path
    add_crumb @user.name, user_path(@user)
    add_crumb 'Pictures', user_pictures_path(@user)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pictures }
    end
  end

  # GET /pictures/1
  # GET /pictures/1.xml
  def show
    add_crumb('Users', users_path) if @user
    add_crumb(@user.name, user_path(@user)) if @user
    add_crumb('Pictures', user_pictures_path(@user)) if @user
    add_crumb 'Pictures', pictures_path unless @user
    add_crumb(@picture.name, user_picture_path(@user, @picture)) if @user
    add_crumb(@picture.name, picture_path(@picture)) unless @user
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @picture }
    end
  end

  # GET /pictures/new
  # GET /pictures/new.xml
  def new
    @picture = Picture.new
    @picture.project = @project
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @picture }
    end
  end

  # GET /pictures/1/edit
  def edit

  end

  # POST /pictures
  # POST /pictures.xml
  def create

    @picture.postDate = Time.now
    if (@picture.flickr)
      hash = Hash.try_convert flickr.photos.getInfo(:photo_id => @picture.flickr)
      hash.each do |key, value|
        if (value.class.to_s =~ /^FlickRaw/)
          hash.delete(key)
        end
      end
      @picture.flickr = hash
    end
    respond_to do |format|
      if @picture.save
        if (@picture.project.pictures.size == @picture.project.size)
          p = @picture.project
          p.closed=true
          p.current = false
          p.save
        end
        format.html { redirect_to([@picture.user,@picture], :notice => 'Picture was successfully created.') }
        format.xml  { render :xml => @picture, :status => :created, :location => @picture }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @picture.errors, :status => :unprocessable_entity }
      end

    end
  end

  # PUT /pictures/1
  # PUT /pictures/1.xml
  def update

    if (params[:picture][:flickr])
      hash = Hash.try_convert flickr.photos.getInfo(:photo_id => params[:picture][:flickr])
      hash.each do |key, value|
        if (value.class.to_s =~ /^FlickRaw/)
          puts 'delete #{key}'
          hash.delete(key)
        end
      end
      params[:picture][:flickr] = hash
    end
    respond_to do |format|
      if @picture.update_attributes(params[:picture])
        format.html { redirect_to(@picture, :notice => 'Picture was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @picture.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pictures/1
  # DELETE /pictures/1.xml
  def destroy

    @picture.destroy

    respond_to do |format|
      format.html { redirect_to(admin_pictures_url) }
      format.xml  { head :ok }
    end
  end


  def admin
  end
end
