require 'sinatra'
require 'mongoid'
require_relative 'models/thing'

Mongoid.load!("config/mongoid.yml")

get '/review' do
  thing = Thing.where(reviewed: false).first

  thing ? thing.to_json : 404
end

post '/things' do
  options = { description: params[:description], reviewed: false }
  thing   = Thing.create!(options)

  201
end

post '/things/:id/sweep' do
  thing = Thing.find(params[:id])
  thing.reviewed = true
  thing.save ? 204 : 422
end
