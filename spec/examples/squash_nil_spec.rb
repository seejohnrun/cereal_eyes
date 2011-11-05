require File.dirname(__FILE__) + '/../spec_helper'

describe CerealEyes do

  before :each do
    Object.send :remove_const, :SampleDocument if defined?(SampleDocument)
  end

  describe 'on a field with squash_nil disabled' do
    
    before :each do
      class SampleDocument
        include CerealEyes::Document
        attribute :name, :squash_nil => false
      end
    end

    describe :serialize do

      it 'should be okay serializing nil in a nested sitation' do
        obj = SampleDocument.new
        obj.serialize.should == { :name => nil }
      end

    end

  end

end
