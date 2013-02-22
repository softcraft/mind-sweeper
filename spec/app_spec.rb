require 'spec_helper'

describe 'mind sweeper' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  let(:idea)            { double('idea') }
  let(:options)          { { description: 'a idea in my mind' } }
  let(:expected_options) { options.merge({reviewed: false}) } 

  it 'takes a idea out of my head into the system' do
    Idea.should_receive(:create!).with(expected_options)
    
    post '/ideas', options 
    
    last_response.status.should == 201
  end
  
  it 'shows first idea collected' do
   Idea.stub(:where).and_return(['idea', 'other_idea'])

   get '/review'
   
   last_response.body.should == 'idea'.to_json
  end

  it 'sweeps a collected idea' do
    Idea.stub(:where).and_return([idea])
    idea.should_receive(:reviewed=).with(true)
    idea.should_receive(:save).and_return(true)

    post '/ideas/sweep'

    last_response.status.should == 204
  end
  
  it 'fails when trying to sweeps someidea wrongly' do
    Idea.stub(:where).and_return([idea])
    idea.stub(:reviewed=).with(true)
    idea.stub(:save).and_return(false)

    post '/ideas/sweep'

    last_response.status.should == 422
  end

  it 'shows noidea if no items to review' do
    Idea.stub(:where).and_return([nil])
    
    get '/review'
    
    last_response.status.should == 404
  end

  context 'integration', type: 'integration' do
    it 'tests everyidea is working as expected' do
      get '/review'
      last_response.status.should == 404

      post '/ideas', options 
      last_response.status.should == 201

      get '/review'
      body = JSON.parse(last_response.body)

      post "/ideas/sweep"
      last_response.status.should == 204

      get '/review'
      last_response.status.should == 404
    end
  end

end

