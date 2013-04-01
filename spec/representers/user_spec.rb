require 'spec_helper'

describe Representers::User do
 
  let(:user) { User.new } 

  subject { user.extend(described_class) }
  before  { subject.to_json }

  it 'renders correctly' do
    subject.links['self'].href.should == "/api/users/#{user.id}"
    subject.links.keys.should == %w{self collect}
  end
end
