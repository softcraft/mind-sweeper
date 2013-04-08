ENV['RACK_ENV'] = 'test'

require_relative '../app.rb'
require 'rspec'
require 'rack/test'

RSpec.configure do |c|
  c.filter_run_excluding :integration => true
end
