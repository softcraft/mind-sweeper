class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :username
  field :password
  
  has_many :ideas, order: :updated_at.asc

  validates_presence_of :username
  validates_presence_of :password

  validates_uniqueness_of :username

end
