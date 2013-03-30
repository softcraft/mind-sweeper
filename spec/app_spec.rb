require 'spec_helper'

describe 'mind sweeper' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'responds correctly' do
    get '/'
    
    last_response.status.should == 200
  context 'root' do
    before { get '/' }

    it 'responds correctly' do
      last_response.status.should == 200
    end
  end
  end

  context 'integration', type: 'integration' do
    let(:root)     { Object.new.extend(Representers::Root) }
    let(:response) { JSON.parse(last_response.body).to_json }

    it 'tests everyidea is working as expected' do
      get '/'
      root.from_json(response)
    end
  end

end

