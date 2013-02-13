class Thing
  include Mongoid::Document

  field :description
  field :reviewed

  def reviewed?
    reviewed == true
  end

  def to_s
    "#{description} | r?: #{reviewed?}, id: #{id}"
  end
end
