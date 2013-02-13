require 'spec_helper'

describe 'mind sweeper' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  let(:thing)            { double('thing') }
  let(:options)          { { description: 'a thing in my mind' } }
  let(:expected_options) { options.merge({reviewed: false}) } 

  it 'takes a thing out of my head into the system' do
    Thing.should_receive(:create!).with(expected_options)
    
    post '/things', options 
    
    last_response.status.should == 201
  end
  
  it 'shows first thing collected' do
   Thing.stub(:where).and_return(['thing', 'other_thing'])

   get '/review'
   
   last_response.body.should == 'thing'.to_json
  end

  it 'sweeps a collected thing' do
    Thing.stub(:find).with('id').and_return(thing)
    thing.should_receive(:reviewed=).with(true)
    thing.should_receive(:save).and_return(true)

    post '/things/id/sweep'

    last_response.status.should == 204
  end
  
  it 'fails when trying to sweeps something wrongly' do
    Thing.stub(:find).with('id').and_return(thing)
    thing.stub(:reviewed=).with(true)
    thing.stub(:save).and_return(false)

    post '/things/id/sweep'

    last_response.status.should == 422
  end

  it 'shows nothing if no items to review' do
    Thing.stub(:where).and_return([nil])
    
    get '/review'
    
    last_response.status.should == 404
  end

  context 'integration', type: 'integration' do
    it 'tests everything is working as expected' do
      get '/review'
      last_response.status.should == 404

      post '/things', options 
      last_response.status.should == 201

      get '/review'
      body = JSON.parse(last_response.body)

      id   = body['_id']
      post "/things/#{id}/sweep"
      last_response.status.should == 204

      get '/review'
      last_response.status.should == 404
    end
  end

end

