class Authentication
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :provider, :type => String
  field :uid, :type => String
  field :token, :type => String
  field :secret, :type => String
  embedded_in :user, :inverse_of => :authentications
  attr_accessible :provider, :uid, :token, :secret
end
