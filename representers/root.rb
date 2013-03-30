require 'roar/representer/json/hal'

module Representers
  module Root

    include Roar::Representer::JSON
    include Roar::Representer::JSON::HAL

    link :self do
      "#{settings.host}/"
    end

    link :signup do
      "#{settings.host}#{settings.signup_path}"
    end

    link :collect do
      ''
    end

    link :decide do
      ''
    end

  end
end