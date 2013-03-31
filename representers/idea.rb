require 'roar/representer/json/hal'

module Representers
  module Idea

    include Roar::Representer::JSON
    include Roar::Representer::JSON::HAL

    link :self do
      "#{settings.host}#{idea_path}"
    end

    link :delete do
      "#{settings.host}#{idea_path}"
    end

    link :review do
      "#{settings.host}#{idea_path}"
    end

    def idea_path
      settings.idea_path.gsub(':idea', id)
    end

  end
end
