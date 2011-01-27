class UsersController < ApplicationController
  before_filter :authenticate_user!, :except =>[:show, :index]
  before_filter :preload_user
  
  before_filter :load_flickraw, :only=>[:last_pictures, :galleries]
  
  def load_flickraw
    FlickRaw.api_key='52c9226e6d1e5c2452366c0f26e5ee11'
    FlickRaw.shared_secret='7248d7d35fd2b1d5'
    auth = @user.authentications.find(:first, :conditions => { :provider => 'flickr' })
    @auth1 = flickr.auth.checkToken :auth_token => auth['token']
  end
  
 
  def index
    @users = User.asc(:name).all
  end
  
  def show
    
  end
  
  def recent_tweets
      # Exchange your oauth_token and oauth_token_secret for an AccessToken instance.

      def prepare_access_token(oauth_token, oauth_token_secret)
          consumer = OAuth::Consumer.new("APIKey", "APISecret",{ :site => "http://api.twitter.com"})
          # now create the access token object from passed values
          token_hash = { :oauth_token => oauth_token,
                                       :oauth_token_secret => oauth_token_secret
                                   }
          access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
          return access_token
      end
      auth = @user.authentications.find(:first, :conditions => { :provider => 'twitter' })

      # Exchange our oauth_token and oauth_token secret for the AccessToken instance.
      access_token = prepare_access_token(auth['token'], auth['secret'])

      # use the access token as an agent to get the home timeline
      response = access_token.request(:get, "http://api.twitter.com/1/statuses/user_timeline.json")

      render :json => response.body
  end
  
  def last_pictures
    @urls = []
    flickr.photos.search(:user_id => 'me').each do |photo|
      puts photo.to_jso
      @urls << FlickRaw.url_s(photo)
    end
  end
  
  def galleries
    @urls = []
    flickr.photosets.getList.each do |photoset|
      @urls << photoset.to_json
    end
    puts @urls
    
  end
  
  def current_project
    @project = @user.current params[:size]
    render 'projects/show'
  end
  

end
