require 'spec_helper'

describe Representers::Idea do
 
  let(:idea) { Idea.new } 

  subject { idea.extend(described_class) }
  before  { subject.to_json }

  it 'renders correctly' do
    subject.links['self'].href.should == "/api/ideas/#{idea.id}"
    subject.links.keys.should == %w{self delete review}
  end
end
