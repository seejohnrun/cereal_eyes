require File.dirname(__FILE__) + '/../spec_helper'

describe CerealEyes do

  before :each do
    Object.send :remove_const, :SampleDocument if defined?(SampleDocument)
  end

  describe 'on a basic object' do

    before :each do
      class SampleDocument 
        include CerealEyes::Document
        attribute :name
      end
    end

    it 'should be able to access attributes' do
      SampleDocument.serialized_attributes.count.should == 1
    end

    describe :deserialize do

      it 'should work' do
        SampleDocument.deserialize({'name' => 'john'}).name.should == 'john'
      end

      it 'should return nil when given nil' do
        SampleDocument.deserialize(nil).should be_nil
      end

      it 'when given keys as symbols' do
        SampleDocument.deserialize({:name => 'john'}).name.should == 'john'
      end

      it 'should do nothing with fields that are not attributes' do
        obj = SampleDocument.deserialize({:other => 'john'})
        obj.should_not respond_to(:other)
        obj.instance_variable_defined?(:@other).should be_false
      end

    end

  end

  describe 'with no attributes set' do

    before :each do
      class SampleDocument
        include CerealEyes::Document
      end
    end

    describe :deserialize do

      it 'should deserialize to a blank object' do
        SampleDocument.deserialize({}).should be_a(SampleDocument)
      end

    end

    describe :serialize do

      it 'should serialize to an empty hash' do
        obj = SampleDocument.new
        obj.serialize.should == {}
      end

    end

  end

end
