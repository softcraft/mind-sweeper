require 'spec_helper'

describe Representers::Root do
  
  subject { Object.new.extend(described_class) }

  it 'renders correctly' do
    subject.to_json
    subject.links.keys.should == %w{self signup collect decide}
  end
end
