require 'spec_helper'
describe 'raagent' do

  context 'with defaults for all parameters' do
    it { should contain_class('raagent') }
  end
end
