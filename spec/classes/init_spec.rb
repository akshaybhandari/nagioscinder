require 'spec_helper'
describe 'nagioscinder' do

  context 'with defaults for all parameters' do
    it { should contain_class('nagioscinder') }
  end
end
