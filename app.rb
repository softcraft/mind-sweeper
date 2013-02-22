require 'sinatra'
require 'mongoid'

require_relative 'models/idea'

Mongoid.load!("config/mongoid.yml")

get '/review' do
  idea = Idea.where(reviewed: false).first

  idea ? idea.to_json : 404
end

post '/ideas' do
  options = { description: params[:description], reviewed: false }
  idea   = Idea.create!(options)

  201
end

post '/ideas/sweep' do
  idea = Idea.where(reviewed: false).first
  idea.reviewed = true
  idea.save ? 204 : 422
end
