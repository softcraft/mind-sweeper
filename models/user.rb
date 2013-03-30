class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :username
  field :password

  validates_presence_of :username
  validates_presence_of :password

  validates_uniqueness_of :username
end
