class Idea
  include Mongoid::Document
  include Mongoid::Timestamps

  field :description

  belongs_to :user

  def to_s
    "#{description} | id: #{id}"
  end
end
