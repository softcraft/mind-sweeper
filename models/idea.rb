class Idea
  include Mongoid::Document
  include Mongoid::Timestamps

  field :description

  def to_s
    "#{description} | id: #{id}"
  end
end
