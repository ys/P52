class PicturesController < ApplicationController
  before_filter :authenticate_user! ,:except =>[:show, :index, :globalIndex]

  before_filter :preload_user, :only =>[:show,:index]
  before_filter :current_user_load, :only =>[:new,:edit,:create, :update, :destroy]

  before_filter :preload_picture!, :except=>[:globalIndex, :new,:index,:create]
  before_filter :load_flickraw, :only=>[:create, :new, :edit, :update]
  before_filter :preload_new_edit, :only=>[:new, :edit]
  before_filter :charge_image_from_params , :only => [:create]
  #before_filter :verify_image! , :only=>[:create]

  def preload_new_edit
    #@pictures = flickr.photos.search(:user_id => 'me', :min_upload_date => (Time.now-1.day).to_i , :max_upload_date => Time.now.to_i )
    @pictures = flickr.photos.search(:user_id => 'me')
    @projects = Project.find(:conditions => {:user_id => @user.id})
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
    auth = @user.authentications.find(:first, :conditions => { :provider => 'flickr' })
    @auth1 = flickr.auth.checkToken :auth_token => auth['token']
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

  def globalIndex
    @pictures = Picture.desc(:postDate).all
    render :index
  end

  # GET /pictures
  # GET /pictures.xml
  def index
    @pictures = @user.pictures
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pictures }
    end
  end

  # GET /pictures/1
  # GET /pictures/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @picture }
    end
  end

  # GET /pictures/new
  # GET /pictures/new.xml
  def new
    @picture = Picture.new
    @project = Project.find(:first, :conditions => {:title =>params[:project_id], :user_id =>@user.id})if (params[:project_id])
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
      format.html { redirect_to(pictures_url) }
      format.xml  { head :ok }
    end
  end
end
