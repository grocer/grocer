require 'spec_helper'
require 'grocer'

describe Grocer do
  let(:environment) { nil }
  before do
      ENV.stubs(:[]).with('RAILS_ENV').returns(environment)
      ENV.stubs(:[]).with('RACK_ENV').returns(environment)
  end

  describe '.env' do
    it 'defaults to development' do
      Grocer.env.should == 'development'
    end

    it 'reads RAILS_ENV from ENV' do
      ENV.stubs(:[]).with('RAILS_ENV').returns('staging')
      Grocer.env.should == 'staging'
    end

    it 'reads RACK_ENV from ENV' do
      ENV.stubs(:[]).with('RACK_ENV').returns('staging')
      Grocer.env.should == 'staging'
    end
  end

end
