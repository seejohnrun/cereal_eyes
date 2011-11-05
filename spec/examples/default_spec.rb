require File.dirname(__FILE__) + '/../spec_helper'

describe CerealEyes do

  before :each do
    Object.send :remove_const, :SampleDocument if defined?(SampleDocument)
  end

  describe 'on a field with a default set' do

    before :each do
      class SampleDocument
        include CerealEyes::Document
        attribute :name, :default => 'something'
      end
    end

    describe :deserialize do

      it 'should keep the value when given' do
        SampleDocument.deserialize({'name' => 'john'}).name.should == 'john'
      end

      it 'should use the default when not given' do
        SampleDocument.deserialize({}).name.should == 'something'
      end

    end

    describe :serialize do

      it 'should override the default if something is set' do
        obj = SampleDocument.new
        obj.name = 'something else'
        obj.serialize.should == { :name => 'something else' }
      end

      it 'should send out the default if set' do
        obj = SampleDocument.new
        obj.serialize.should == { :name => 'something' }
      end

    end

  end

end
