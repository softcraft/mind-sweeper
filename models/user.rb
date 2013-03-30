class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :username
  field :password
  
  has_one  :next_idea, class_name: 'Idea'
  has_many :ideas

  validates_presence_of :username
  validates_presence_of :password

  validates_uniqueness_of :username
end
