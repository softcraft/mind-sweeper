require 'sinatra'
require 'sinatra/config_file'
require 'mongoid'
require 'sinatra'
require 'sinatra/cross_origin'

require_relative 'models/idea'
require_relative 'models/user'
require_relative 'representers/root'
require_relative 'representers/idea'
require_relative 'representers/user'

configure do
  enable :cross_origin
  set :allow_methods, [:get, :post, :options, :put]
end

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
  if user = User.where(params).first
    redirect settings.user_path.gsub(":user", user.id)
  else
    422
  end
end

post settings.collect_path do
  idea = Idea.create(description: params[:description],
                     user_id: params[:user])

  idea.save ? 201 : 422
end

put settings.idea_path do
  begin
    idea = Idea.find(params[:idea])
    datetime = DateTime.parse(params[:datetime])
    idea.update_attributes!(datetime: datetime)
    204
  rescue
    422
  end
end

put settings.review_path do
  idea = Idea.find(params[:idea])

  idea.touch
  204
end

put settings.do_path do
  idea = Idea.find(params[:idea])

  idea.update_attributes(datetime: DateTime.now) ? 204 : 422
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
