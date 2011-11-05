require File.dirname(__FILE__) + '/../spec_helper'

describe CerealEyes do

  before :each do
    Object.send :remove_const, :SampleDocument if defined?(SampleDocument)
  end

  describe 'with a different name set' do

    before :each do
      class SampleDocument
        include CerealEyes::Document
        attribute :name, :name => :real_name
      end
    end

    describe :deserialize do

      it 'should accept data from the serialized name' do
        SampleDocument.deserialize({'real_name' => 'john'}).name.should == 'john'
      end

      it 'should not accept data from the original name' do
        SampleDocument.deserialize({'name' => 'john'}).name.should be_nil
      end

    end

    describe :serialize do

      it 'should name correctly on the way out' do
        obj = SampleDocument.new
        obj.name = 'john'
        obj.serialize.should == { :real_name => 'john' }
      end

      it 'should not respond to aliased names' do
        obj = SampleDocument.new
        obj.should_not respond_to(:real_name=)
      end

    end

  end

end
