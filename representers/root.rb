require 'roar/representer/json/hal'

module Representers
  module Root

    include Roar::Representer::JSON
    include Roar::Representer::JSON::HAL

    link :self do
      'http://localhost:9292/'
    end

    link :signup do
      ''
    end

    link :collect do
      ''
    end

    link :decide do
      ''
    end

  end
end
