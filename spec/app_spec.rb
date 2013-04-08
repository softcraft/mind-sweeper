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
      user.stub(:first_idea)
      Idea.stub(:where).and_return(Mongoid::Criteria.new(Idea))
    end

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

    before do
      user.stub(:first_idea)
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
    let(:root)     { Object.new.extend(Representers::Root) }
    let(:user)     { User.last.extend(Representers::User) }
    let(:signup)   { root.links[:signup].href }
    let(:login)    { root.links[:login].href }
    let(:collect)  { user.links[:collect].href }
    let(:review_idea)   { next_idea.links[:review].href }
    let(:delete_idea)   { next_idea.links[:delete].href }
    let(:do_idea)       { next_idea.links[:do].href }
    let(:next_idea)     do
      idea =  user.next_idea.extend(Representers::Idea)
      idea.to_json
      idea
    end
    let(:collected_idea) do
      idea = user.next_idea
      idea.to_json
      idea
    end
    let(:schedule_date) { "2013/09/02 10:00 CST" }

    before :all do
      get '/api'
      root_response = JSON.parse(last_response.body).to_json
      root.from_json(root_response)

      post signup, params
    end

    before do
      post login, params
      login_response = JSON.parse(last_response.body).to_json
      user.from_json(login_response)
    end

    after do
      User.last.delete if User.count > 0
    end

    it 'collects and deletes an idea' do
      post   collect, { description: 'new idea' }
      delete delete_idea
      user.next_idea.should == nil
    end

    it 'collects and reviews an idea' do
      post   collect, { description: 'first idea' }
      post   collect, { description: 'second idea' }
      put review_idea
      user.next_idea.description.should == 'second idea'
    end

    it 'collects and does an idea' do
      post   collect, { description: 'new idea' }
      put do_idea
      user.next_idea.datetime.to_s.should == DateTime.now.to_s
    end

    it 'collects and schedules an idea' do
      post   collect, { description: 'new idea' }
      put do_idea
      put collected_idea.links[:schedule].href, { datetime: schedule_date }
      user.next_idea.datetime.should == schedule_date
    end
  end

end

