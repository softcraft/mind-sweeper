require 'spec_helper'

describe 'mind sweeper' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  let(:params) { {username: 'username', password: 'password'} }

  context 'root' do
    before { get '/' }

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
    let(:login_path) { settings.login_path.gsub(':user', 'username') }

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

  context 'integration', type: 'integration' do
    let(:root)     { Object.new.extend(Representers::Root) }
    let(:user)     { User.last.extend(Representers::User) }
    let(:signup)   { root.links[:signup].href }
    let(:login)    { root.links[:login].href }
    let(:collect)  { user.links[:collect].href }

    before do
      get '/'
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
      post collect, { description: 'new idea' }
      last_response.status.should == 201
    end
  end

end

