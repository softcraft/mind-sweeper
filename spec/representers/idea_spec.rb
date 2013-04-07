require 'spec_helper'

describe Representers::Idea do
 
  let(:idea) { Idea.new }

  subject { idea.extend(described_class) }

  it 'renders review links corretly' do
    subject.to_json

    subject.links['self'].href.should == "/api/ideas/#{idea.id}"
    subject.links.keys.should == %w{self delete review do}
  end

  it 'renders do links corretly' do
    idea.datetime = DateTime.now

    subject.to_json

    subject.links['self'].href.should == "/api/ideas/#{idea.id}"
    subject.links.keys.should == %w{self delete schedule}
  end
end
