require 'roar/representer/json/hal'

module Representers
  module User

    include Roar::Representer::JSON
    include Roar::Representer::JSON::HAL

    link :self do
      "#{settings.host}#{user_path}"
    end

    link :collect do
      "#{settings.host}#{collect_path}"
    end

    collection :first_idea, {
      from: 'ideas',
      class: Idea,
      extend: Representers::Idea,
      embedded: true
    }

    def user_path
      settings.user_path.gsub(':user', id)
    end

    def collect_path
      settings.collect_path.gsub(':user', id)
    end

  end
end
