class User
  include Mongoid::Document
  include Mongoid::Paperclip
  
  field :name
  embeds_many :authentications
  references_many :projects
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
  
end
