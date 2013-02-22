require 'sinatra'
require 'mongoid'

require_relative 'models/idea'

Mongoid.load!("config/mongoid.yml")

get '/review' do
  idea = Idea.where(reviewed: false).first

  idea ? redirect '/app.html' : 404
end

post '/ideas' do
  options = { description: params[:description], reviewed: false }
  idea   = Idea.create!(options)

  redirect '/app.html'
end

post '/ideas/sweep' do
  idea = Idea.find(params[:id])
  idea.reviewed = true
  idea.save ? redirect '/app.html' : 422
end
