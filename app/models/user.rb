class User
  include Mongoid::Document
  include Mongoid::Paperclip
  
  field :name
  embeds_many :authentications
  references_many :projects, :dependent => :delete
  has_attached_file :avatar,
      :url => "/images/avatars/:id/:style.:extension" ,
      :path           => 'public/images/avatars/:id/:style.:extension',
      :styles => {
        :original => ['1920x1680>', :jpg],
        :square    => ['100x100#',   :jpg],
        :small    => ['150x100#',   :jpg],
        :medium   => ['250x250',    :jpg],
        :large    => ['500x500>',   :jpg]
      }
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates_presence_of :name
  validates_uniqueness_of :name, :email, :case_sensitive => false
  def to_param
    name
  end
  def to_s
    name
  end
  
  def pictures
    projects = Project.where(:user_id => id).map(&:_id)
    Picture.where(:project_id.in => projects)
  end
  
  def can_have_project? size
    project= Project.find(:first, :conditions =>{:user_id => id, :size => size, :current => true})
    if project == nil
      true
    else
      false
    end
  end
  def current size
    Project.find(:first, :conditions =>{:user_id => id, :size => size, :current => true})
  end
  
  def authenticated_to_flickr?
    auth = authentications.find(:first, :conditions => { :provider => 'flickr' })
    if auth == nil
      false
    else
      true
    end
  end
  
  def avatar_url
    if Avatar::source.avatar_url_for(self, :size => 75)
      Avatar::source.avatar_url_for(self, :size => 75)
    elsif avatar.url
      avatar.url(:square)
    else
      'blank.gif'
    end
  end
  
end
