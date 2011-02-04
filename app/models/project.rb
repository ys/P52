class Project
  include Mongoid::Document
  include Mongoid::Timestamps




  field :size, :type => Integer
  field :endingDate, :type => Date
  field :description, :type => String
  field :title, :type => String
  field :current, :type => Boolean
  field :closed, :type => Boolean
  referenced_in :user, :inverse_of => :projects
  references_many :pictures, :dependent => :delete

  attr_protected :size
  validates_presence_of :size
  validates_inclusion_of :size, :in => [365,52,12]
  validates_length_of :title, :minimum=>1, :maximum => 255, :allow_blank => false
  validates_uniqueness_of :title, :scope => :user_id

  def to_param
    title
  end

  def numberOfPictures
    size - pictures.size
  end

  def archive
    closed = false
  end

  def last_picture
    Picture.where(:project_id => id).desc(:postDate).first
  end
  
  def url_s
    picture = Picture.where(:project_id => id).desc(:postDate).first
    if picture
      picture.url_s
    else
     'blank.gif'
    end
  end
  def url_m
    picture = Picture.where(:project_id => id).desc(:postDate).first
    if picture
      picture.url_m
    else
     'blank.gif'
    end
  end

  def can_post_picture?
    (current && !closed && (size > pictures.size))
  end

  def can_have_new_picture?
     return true if last_picture == nil
    case size
    when 12
      last_picture.postDate.strftime("%m") != Time.now.strftime("%m")
    when 52
      last_picture.postDate.strftime("%W") != Time.now.strftime("%W")
    when 365
      last_picture.postDate.strftime("%Y%m%d") != Time.now.strftime("%Y%m%d")
    else false
    end
 
  end
  
 

end
