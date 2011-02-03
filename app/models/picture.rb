class Picture
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps
  
  
  field :pictureId, :type => Integer
  field :postDate, :type => Time
  field :description, :type => String
  field :title, :type => String
  referenced_in :project, :inverse_of => :pictures
  field :flickr, :type => Hash

  def user
    project.user
  end
  
 
  PHOTO_SOURCE_URL='http://farm%s.static.flickr.com/%s/%s_%s%s.%s'.freeze
 
  def url();   PHOTO_SOURCE_URL % [flickr['farm'], flickr['server'], flickr['id'], flickr['secret'], "",   "jpg"]   end
  def url_m(); PHOTO_SOURCE_URL % [flickr['farm'], flickr['server'], flickr['id'], flickr['secret'], "_m", "jpg"] end
  def url_s(); PHOTO_SOURCE_URL % [flickr['farm'], flickr['server'], flickr['id'], flickr['secret'], "_s", "jpg"] end
  def url_t(); PHOTO_SOURCE_URL % [flickr['farm'], flickr['server'], flickr['id'], flickr['secret'], "_t", "jpg"] end
  def url_b(); PHOTO_SOURCE_URL % [flickr['farm'], flickr['server'], flickr['id'], flickr['secret'], "_b", "jpg"] end
  def url_z(); PHOTO_SOURCE_URL % [flickr['farm'], flickr['server'], flickr['id'], flickr['secret'], "_z", "jpg"] end
  def url_o(); PHOTO_SOURCE_URL % [flickr['farm'], flickr['server'], flickr['id'], flickr['secret'], "_o", "jpg"] end

end
