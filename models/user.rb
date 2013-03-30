class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :username
  field :password
end
