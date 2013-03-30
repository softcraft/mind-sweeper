require 'sinatra'
require 'sinatra/config_file'
require 'mongoid'

require_relative 'models/idea'
require_relative 'models/user'
require_relative 'representers/root'

config_file 'config/config.yml'
Mongoid.load!("config/mongoid.yml")

get '/' do
  Object.new.extend(Representers::Root).to_json
end

post settings.signup_path do
  user = User.create(params)
  
  user.save ? 201 : 422
end
