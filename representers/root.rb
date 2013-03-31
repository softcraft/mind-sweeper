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

    link :login do
      "#{settings.host}#{settings.login_path}"
    end

  end
end
