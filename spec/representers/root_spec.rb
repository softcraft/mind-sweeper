require 'spec_helper'

describe Representers::Root do
  
  subject { Object.new.extend(described_class) }
  before  { subject.to_json }

  it 'renders correctly' do
    subject.links['self'].href.should == '/'
    subject.links.keys.should == %w{self signup login}
  end
end
