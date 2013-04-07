class Idea
  include Mongoid::Document
  include Mongoid::Timestamps

  field :description
  field :datetime, type: DateTime

  belongs_to :user

  def to_s
    "#{description} | id: #{id}"
  end
end
