require 'spec_helper'

describe 'mind sweeper' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  let(:params) { {username: 'username', password: 'password'} }

  context 'root' do
    before { get '/api' }

    it 'responds correctly' do
      last_response.status.should == 200
    end
  end

  context 'signup' do

    let(:user)   { double('user') }

    before do
      User.should_receive(:create).with(params.stringify_keys).
        and_return(user)
    end

    subject do
      post settings.signup_path, params
      last_response.status
    end

    it 'creates a user' do
      user.stub(:save).and_return(true)
      subject.should == 201
    end

    it 'returns error if error creating user' do
      user.stub(:save).and_return(false)
      subject.should == 422
    end

  end

  context 'login' do

    let(:user)       { User.new }
    let(:login_path) { settings.login_path }

    subject do
      post login_path, params
      last_response.status
    end

    it 'responds succesfully' do
      User.stub(:where).with(params.stringify_keys).and_return([user])
      subject.should == 200
    end

    it 'rejects wrong credentials' do
      User.stub(:where).and_return([])
      subject.should == 422
    end
  end

  context 'user' do

    let(:user)       { User.new }
    let(:user_path) { settings.user_path.gsub(':user', user.id) }

    subject do
      get user_path, params
      last_response.status
    end

    it 'responds succesfully' do
      User.stub(:find).and_return(user)
      subject.should == 200
    end

    it 'rejects wrong user' do
      User.stub(:find).and_return(nil)
      subject.should == 422
    end
  end
  context 'collect' do

    let(:user)   { double('user') }
    let(:idea)   { double('idea') }
    let(:params) { { description: 'new idea' } }
    let(:options) { params.merge(user_id: ':user') }

    before do
      Idea.should_receive(:create).with(options).
        and_return(idea)
    end

    subject do
      post settings.collect_path, params
      last_response.status
    end

    it 'creates a user idea' do
      idea.stub(:save).and_return(true)
      subject.should == 201
    end

    it 'returns error if error creating idea' do
      idea.stub(:save).and_return(false)
      subject.should == 422
    end

  end

  context 'review' do

    let(:idea)   { double('idea') }

    before do
      Idea.stub(:find).and_return(idea)
    end

    subject do
      put settings.idea_path
      last_response.status
    end

    it 'touches an idea' do
      idea.should_receive(:touch)
      subject.should == 204
    end

  end

  context 'delete' do

    let(:idea)   { double('idea') }

    before do
      Idea.stub(:find).and_return(idea)
    end

    subject do
      delete settings.idea_path
      last_response.status
    end

    it 'touches an idea' do
      idea.should_receive(:delete)
      subject.should == 204
    end

  end

  context 'integration', type: 'integration' do
    let(:root)     { Object.new.extend(Representers::Root) }
    let(:user)     { User.last.extend(Representers::User) }
    let(:signup)   { root.links[:signup].href }
    let(:login)    { root.links[:login].href }
    let(:collect)  { user.links[:collect].href }
    let(:review_idea)   { idea.links[:review].href }
    let(:delete_idea)   { idea.links[:delete].href }
    let(:idea)     do
      idea =  user.ideas.first.extend(Representers::Idea)
      idea.to_json
      idea
    end 

    before do
      get '/api'
      root_response = JSON.parse(last_response.body).to_json
      root.from_json(root_response)
    end

    after do
      User.last.delete
    end

    it 'tests everything is working as expected' do
      post signup, params
      post login, params
      login_response = JSON.parse(last_response.body).to_json
      user.from_json(login_response)
      
      post   collect, { description: 'new idea' }
      put    review_idea
      delete delete_idea 
      user.ideas.should == []
    end
  end

end

