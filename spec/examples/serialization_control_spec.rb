require File.dirname(__FILE__) + '/../spec_helper'

describe CerealEyes do

  before :each do
    Object.send :remove_const, :SampleDocument if defined?(SampleDocument)
  end

  describe 'on a field with deserialize off' do

    before :each do
      class SampleDocument
        include CerealEyes::Document
        attribute :name, :deserialize => false
      end
    end

    describe :deserialize do

      it 'should skip the field on deserialize even if its given' do
        SampleDocument.deserialize({:name => 'john'}).should_not respond_to(:name)
      end

    end

  end

  describe 'on a field with serialize off' do

    before :each do
      class SampleDocument
        include CerealEyes::Document
        attribute :name, :serialize => false
      end
    end

    describe :serialize do
      it 'should skip the field on the way out' do
        obj = SampleDocument.new
        obj.class.send(:attr_writer, :name)
        obj.name = 'john'
        obj.serialize.should == {}
      end
    end

  end

end
