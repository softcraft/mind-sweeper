require 'roar/representer/json/hal'

module Representers
  module Idea

    include Roar::Representer::JSON
    include Roar::Representer::JSON::HAL

    property :description
    property :datetime

    link :self do
      "#{settings.host}#{idea_path}"
    end

    link :delete do
      "#{settings.host}#{idea_path}"
    end

    link :review do
      "#{settings.host}#{review_path}" unless datetime
    end

    link :do do
      "#{settings.host}#{do_path}" unless datetime
    end

    link :schedule do
      "#{settings.host}#{idea_path}" if datetime
    end

    private

    def idea_path
      settings.idea_path.gsub(':idea', id)
    end

    def review_path
      settings.review_path.gsub(':idea', id)
    end

    def do_path
      settings.do_path.gsub(':idea', id)
    end

  end
end
