class PicturesController < ApplicationController
  before_filter :preload_user
  before_filter :current_user_load, :only =>[:new,:edit,:create, :update, :destroy]
  before_filter :load_flickraw, :only=>[:create]
  
  def load_flickraw
    FlickRaw.api_key='52c9226e6d1e5c2452366c0f26e5ee11'
    FlickRaw.shared_secret='7248d7d35fd2b1d5'
    auth = @user.authentications.find(:first, :conditions => { :provider => 'flickr' })
    @auth1 = flickr.auth.checkToken :auth_token => auth['token']
  end
  # GET /pictures
  # GET /pictures.xml
  def index
    @pictures = Picture.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pictures }
    end
  end

  # GET /pictures/1
  # GET /pictures/1.xml
  def show
    @picture = Picture.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @picture }
    end
  end

  # GET /pictures/new
  # GET /pictures/new.xml
  def new
    @picture = Picture.new
    @pictures = flickr.photos.search(:user_id => 'me')
    @projects = Project.find(:conditions => {:user_id => @user.id})
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @picture }
    end
  end

  # GET /pictures/1/edit
  def edit
    @picture = Picture.find(params[:id])
  end

  # POST /pictures
  # POST /pictures.xml
  def create
    @picture = Picture.new(params[:picture])
    if (@picture.flickr)
      hash = Hash.try_convert flickr.photos.getInfo(:photo_id => @picture.flickr)
      hash.each do |key, value| 
        if (value.class.to_s =~ /^FlickRaw/) 
          puts 'delete #{key}'
          hash.delete(key) 
        end
      end
      @picture.flickr = hash
    end
    
    respond_to do |format|
      if @picture.save
        format.html { redirect_to(@picture, :notice => 'Picture was successfully created.') }
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
    @picture = Picture.find(params[:id])

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
    @picture = Picture.find(params[:id])
    @picture.destroy

    respond_to do |format|
      format.html { redirect_to(pictures_url) }
      format.xml  { head :ok }
    end
  end
end
