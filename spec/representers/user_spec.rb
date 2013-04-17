require 'spec_helper'

describe Representers::User do
 
  let(:user) { User.new } 

  subject { user.extend(described_class) }

  before do
    user.stub(:ordered_ideas)
    Idea.stub(:where).and_return(Mongoid::Criteria.new(Idea))
    subject.to_json
  end

  it 'renders correctly' do
    subject.links['self'].href.should == "/api/users/#{user.id}"
    subject.links.keys.should == %w{self collect}
  end
end
