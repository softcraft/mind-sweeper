require 'spec_helper'

describe 'mind sweeper' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  context 'root' do
    before { get '/' }

    it 'responds correctly' do
      last_response.status.should == 200
    end
  end

  context 'signup' do

    let(:params) { {username: 'username', password: 'password'} }
    let(:user)   { double('user') }

    before do
      User.should_receive(:create).with(params.stringify_keys!).
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

  context 'integration', type: 'integration' do
    let(:root)     { Object.new.extend(Representers::Root) }
    let(:signup)   { root.links[:signup].href }
    let(:params) { {username: 'username', password: 'password'} }

    before do
      get '/'
      response = JSON.parse(last_response.body).to_json
      root.from_json(response)
    end

    after do
      User.last.delete
    end

    it 'tests everything is working as expected' do
      post signup, params
      last_response.status.should == 201
    end
  end

end

