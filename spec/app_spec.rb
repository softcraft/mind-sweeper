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

    before do
      user.stub(:ordered_ideas)
      Idea.stub(:where).and_return(Mongoid::Criteria.new(Idea))
    end

    subject do
      post login_path, params
      last_response.status
    end

    it 'responds succesfully' do
      User.stub(:where).with(params.stringify_keys).and_return([user])
      subject.should == 302
    end

    it 'rejects wrong credentials' do
      User.stub(:where).and_return([])
      subject.should == 422
    end
  end

  context 'user' do

    let(:user)       { User.new }
    let(:user_path) { settings.user_path.gsub(':user', user.id) }

    before do
      user.stub(:ordered_ideas)
      Idea.stub(:where).and_return(Mongoid::Criteria.new(Idea))
    end

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

  context 'update' do

    let(:idea)   { double('idea') }

    before do
      Idea.stub(:find).and_return(idea)
    end

    context 'review' do
      subject do
        put settings.review_path
        last_response.status
      end

      it 'touches an idea' do
        idea.should_receive(:touch)
        subject.should == 204
      end
    end

    context 'do' do

      let(:params) { {datetime: DateTime.now} }

      before { DateTime.stub(:now).and_return(DateTime.now) }

      subject do
        put settings.do_path
        last_response.status
      end

      it 'updates dates of an idea' do
        idea.should_receive(:update_attributes).with(params).
          and_return(true)

        subject.should == 204
      end
    end

    context 'schedule' do

      let(:datetime) { "2022/09/01 22:00 CST" }
      let(:params) { {datetime: datetime} }
      let(:expected_params) { { datetime: DateTime.parse(datetime)}}

      subject do
        put settings.idea_path, params
        last_response.status
      end

      it 'updates dates of an idea' do
        idea.should_receive(:update_attributes!).with(expected_params).
          and_return(true)

        subject.should == 204
      end
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

  context 'integration', integration: true do
    let(:root)          { Object.new.extend(Representers::Root) }
    let(:signup)        { root.links[:signup].href }
    let(:login)         { root.links[:login].href }
    let(:schedule_date) { "2033/09/02 10:00 CST" }

    before do
      get '/api'
      root.from_json(last_response.body)

      post signup, params
      post login,  params
      get last_response.headers['Location']
      @user_response = JSON.parse(last_response.body)
    end

    after do
      User.last.delete if User.count > 0
    end

    it 'works as expected' do
      user_collect = @user_response["_links"]["collect"]["href"]
      user_self    = @user_response["_links"]["self"]["href"]

      # collect
      post user_collect, { description: 'first idea' }
      post user_collect, { description: 'second idea' }

      get user_self
      user_response = JSON.parse(last_response.body)
      user_ideas    = user_response["_embedded"]["ideas"]

      user_ideas.first["description"].should == "first idea"

      # review
      idea_review = user_ideas.first["_links"]["review"]["href"]

      put idea_review

      get user_self
      user_response = JSON.parse(last_response.body)
      user_ideas    = user_response["_embedded"]["ideas"]

      user_ideas.first["description"].should == "second idea"

      #delete
      idea_delete = user_ideas.first["_links"]["delete"]["href"]

      delete idea_delete

      get user_self
      user_response = JSON.parse(last_response.body)
      user_ideas    = user_response["_embedded"]["ideas"]

      user_ideas.first["description"].should == "first idea"

      #do
      idea_do = user_ideas.first["_links"]["do"]["href"]

      put idea_do

      get user_self
      user_response = JSON.parse(last_response.body)
      user_ideas    = user_response["_embedded"]["ideas"]

      #schedule
      user_schedule = user_ideas.first["_links"]["schedule"]["href"]

      put user_schedule, { datetime: schedule_date }

      get user_self
      user_response = JSON.parse(last_response.body)
      user_ideas    = user_response["_embedded"]["ideas"]

      user_ideas.should == []
    end

  end

end

