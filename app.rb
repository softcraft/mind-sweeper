require 'sinatra'
require 'mongoid'

require_relative 'models/idea'
require_relative 'representers/root'

Mongoid.load!("config/mongoid.yml")

get '/' do
  Object.new.extend(Representers::Root).to_json
end
