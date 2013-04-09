class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :username
  field :password

  has_many :ideas, order: [:datetime.desc, :updated_at.asc]

  validates_presence_of :username
  validates_presence_of :password

  validates_uniqueness_of :username

  def first_idea
    selected_ideas = ideas.reject do |i|
      i.datetime > DateTime.now if i.datetime
    end

    selected_ideas.first ? [selected_ideas.first] : []
  end
end
