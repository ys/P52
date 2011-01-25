class Picture
  include Mongoid::Document
  include Mongoid::Paperclip
  field :pictureId, :type => Integer
  field :postDate, :type => Date
  field :description, :type => String
  field :title, :type => String
  referenced_in :project, :inverse_of => :pictures
  field :flickr, :type => Hash
  has_attached_file :image,
    :url => "/images/user/:project.user.name/projects/:project_name/:id/:style.:extension" ,
    :path           => 'public/images/avatars/:id/:style.:extension',
  :styles => {
    :original => ['1920x1680>', :jpg],
    :square    => ['100x100#',   :jpg],
    :small    => ['150x100#',   :jpg],
    :medium   => ['250x250',    :jpg],
    :large    => ['500x500>',   :jpg]
  }


 
  PHOTO_SOURCE_URL='http://farm%s.static.flickr.com/%s/%s_%s%s.%s'.freeze
 
  def url();   PHOTO_SOURCE_URL % [flickr['farm'], flickr['server'], flickr['id'], flickr['secret'], "",   "jpg"]   end
  def url_m(); PHOTO_SOURCE_URL % [flickr['farm'], flickr['server'], flickr['id'], flickr['secret'], "_m", "jpg"] end
  def url_s(); PHOTO_SOURCE_URL % [flickr['farm'], flickr['server'], flickr['id'], flickr['secret'], "_s", "jpg"] end
  def url_t(); PHOTO_SOURCE_URL % [flickr['farm'], flickr['server'], flickr['id'], flickr['secret'], "_t", "jpg"] end
  def url_b(); PHOTO_SOURCE_URL % [flickr['farm'], flickr['server'], flickr['id'], flickr['secret'], "_b", "jpg"] end
  def url_z(); PHOTO_SOURCE_URL % [flickr['farm'], flickr['server'], flickr['id'], flickr['secret'], "_z", "jpg"] end

end
