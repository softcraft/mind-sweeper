require 'sinatra'
require 'sinatra/config_file'
require 'mongoid'

require_relative 'models/idea'
require_relative 'models/user'
require_relative 'representers/root'
require_relative 'representers/idea'
require_relative 'representers/user'

config_file 'config/config.yml'
Mongoid.load!("config/mongoid.yml")

get '/api' do
  Object.new.extend(Representers::Root).to_json
end

post settings.signup_path do
  user = User.create(params)

  user.save ? 201 : 422
end

post settings.login_path do
  user = User.where(params).first

  user ? user.extend(Representers::User).to_json : 422
end

post settings.collect_path do
  idea = Idea.create(description: params[:description],
                     user_id: params[:user])

  idea.save ? 201 : 422
end

put settings.idea_path do
  idea = Idea.find(params[:idea])
  idea.touch

  204
end

delete settings.idea_path do
  idea = Idea.find(params[:idea])
  idea.delete

  204
end

get settings.user_path do
  user = User.find(params[:user])

  user ? user.extend(Representers::User).to_json : 422
end

get '/' do
  erb :index
end
