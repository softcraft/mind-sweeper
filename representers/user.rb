require 'roar/representer/json/hal'

module Representers
  module User

    include Roar::Representer::JSON
    include Roar::Representer::JSON::HAL

    property :next_idea, :embedded => true

    link :self do
      "#{settings.host}#{user_path}"
    end

    link :collect do
      "tbd"
    end

    def user_path
      settings.user_path.gsub(':user', id)
    end
  end
end
