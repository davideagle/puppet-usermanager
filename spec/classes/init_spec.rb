require 'spec_helper'
describe 'usermanager' do

  context 'with defaults for all parameters' do
    it { should contain_class('usermanager') }
  end
end
