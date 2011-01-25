class Project
  include Mongoid::Document
  field :size, :type => Integer
  field :endingDate, :type => Date
  field :description, :type => String
  field :title, :type => String
  referenced_in :user, :inverse_of => :projects
  references_many :pictures
  validates_inclusion_of :size, :in => [365,52,12]
  
  validates_uniqueness_of :title, :scope => :user_id
  
  def to_param
    title
  end
  
end
