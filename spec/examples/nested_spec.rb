require File.dirname(__FILE__) + '/../spec_helper'

describe CerealEyes do

  before :each do
    Object.send :remove_const, :SampleDocument if defined?(SampleDocument)
  end

  describe 'on a field with a nested object' do
    
    before :each do
      class SampleDocument
        include CerealEyes::Document
        attribute :name, :default => 'nothing'
        attribute :inner_john, :type => self
      end
    end

    describe :deserialize do

      it 'should deserialize properly' do
        obj = SampleDocument.deserialize({'inner_john' => { 'name' => 'something' }})
        obj.name.should == 'nothing'
        obj.inner_john.should be_a SampleDocument
        obj.inner_john.name.should == 'something'
      end

      it 'should return nil when a nested field has a nil value' do
        obj = SampleDocument.deserialize({'inner_john' => nil})
        obj.inner_john.should be_nil
      end

    end

    describe :serialize do

      it 'should automatically serialize nested objects' do
        obj = SampleDocument.new
        obj.inner_john = SampleDocument.new
        obj.inner_john.name = 'something'
        obj.serialize.should == { :inner_john => { :name => 'something' }, :name => 'nothing' }
      end

      it 'should be okay serializing nil in a nested sitation' do
        obj = SampleDocument.new
        obj.inner_john = nil
        obj.serialize.should == { :name => 'nothing' }
      end

    end

  end

end
