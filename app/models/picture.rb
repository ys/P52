class Picture
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps
  
  cattr_reader :per_page
  @@per_page = 3
  
  field :pictureId, :type => Integer
  field :postDate, :type => Time
  field :description, :type => String
  field :title, :type => String
  referenced_in :project, :inverse_of => :pictures
  field :flickr, :type => Hash
  has_attached_file :image,
    :styles => { :medium => "300x300>", :thumb => "100x100>", :square => "300x300#" , :web =>"1000x1000>"},
    :storage => :googlestorage,
    :bucket => "eatcpcks",
    :path => "p52/:attachment/:id/:style.:extension",
    :google_storage_credentials => "#{RAILS_ROOT}/config/storage.yml"
    
    
    validates_presence_of :flickr, :unless => :image
    validates_presence_of :image, :unless => :flickr
    validate :one_or_the_other
    def one_or_the_other
    
      if (!image.file? && flickr.blank?)
        errors.add_to_base("You must either upload a file or choose one from flickr!")
      end
    end
    # Paperclip Validations
    #validates_attachment_presence :image
    #validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/pjpeg', 'image/jpg']
    #validates_attachment_size :image, :less_than => 10.megabytes,
    #    :message => 'filesize must be less than 10 MegaBytes'
    #  validates_attachment_content_type :image, :content_type => [ 'image/jpeg' ],
    #                :message => 'file must be of filetype .jpeg'
  def user
    project.user
  end
  
  def name
    if flickr
      flickr["title"]
    else
      title
    end
  end
 
 
  PHOTO_SOURCE_URL='http://farm%s.static.flickr.com/%s/%s_%s%s.%s'.freeze
 
  def url()
      
    return PHOTO_SOURCE_URL % [flickr['farm'], flickr['server'], flickr['id'], flickr['secret'], "",   "jpg"] if flickr
    return image.url
  end
  def url_m()
     return PHOTO_SOURCE_URL % [flickr['farm'], flickr['server'], flickr['id'], flickr['secret'], "_m", "jpg"] if flickr
     return image.url(:medium)
  end
  def url_s()
     return PHOTO_SOURCE_URL % [flickr['farm'], flickr['server'], flickr['id'], flickr['secret'], "_s", "jpg"] if flickr
     return image.url(:square)
  end
  def url_t()
     return PHOTO_SOURCE_URL % [flickr['farm'], flickr['server'], flickr['id'], flickr['secret'], "_t", "jpg"] if flickr
     return image.url(:thumb)
  end
  def url_b()
     return PHOTO_SOURCE_URL % [flickr['farm'], flickr['server'], flickr['id'], flickr['secret'], "_b", "jpg"] if flickr
     return image.url(:web)
  end
  def url_z()
     return PHOTO_SOURCE_URL % [flickr['farm'], flickr['server'], flickr['id'], flickr['secret'], "_z", "jpg"] if flickr
     return image.url(:web)
  end
  def url_o()
     return PHOTO_SOURCE_URL % [flickr['farm'], flickr['server'], flickr['id'], flickr['secret'], "_o", "jpg"] if flickr
     return image.url
  end
 
end
