require File.dirname(__FILE__) + '/../spec_helper'

describe CerealEyes do

  before :each do
    Object.send :remove_const, :SampleDocument if defined?(SampleDocument)
  end

  describe 'name conflicts' do

    describe 'two attributes with the same name, that would fail for serialization' do

      it 'should raise an error on construction' do
        lambda do
          class SampleDocument
            include CerealEyes::Document
            attribute :name1, :name => :real_name
            attribute :name2, :name => :real_name
          end
        end.should raise_error(CerealEyes::AttributeError)
      end

    end

    describe 'two attributes with the same field, that fail for deserialization' do

      it 'should raise an error on contruction' do
        lambda do
          class SampleDocument
            include CerealEyes::Document
            attribute :name, :name => :real_name1
            attribute :name, :name => :real_name2
          end
        end.should raise_error(CerealEyes::AttributeError)
      end

      it 'should raise an error on contruction with no names set' do
        lambda do
          class SampleDocument
            include CerealEyes::Document
            attribute :name
            attribute :name
          end
        end.should raise_error(CerealEyes::AttributeError)
      end

    end

    describe 'the same field being deserialized multiple ways, only serialized one way' do

      before :each do
        class SampleDocument
          include CerealEyes::Document
          attribute :name1, :name => :real_name
          attribute :name2, :name => :real_name, :serialize => false
        end
      end

      describe :deserialize do
         
        it 'should deserialize in both directions' do
          obj = SampleDocument.deserialize({:real_name => 'john'})
          obj.name1.should == 'john'
          obj.name2.should == 'john'
        end

      end

      describe :serialize do

        it 'should be okay' do
          obj = SampleDocument.new
          obj.name1 = 'john'
          obj.serialize.should == { :real_name => 'john' }
        end

      end

    end

    describe 'the same field being serialized multiple ways, only deserialized one way' do

      before :each do
        class SampleDocument
          include CerealEyes::Document
          attribute :name, :name => :real_name
          attribute :name, :deserialize => false
        end
      end

      describe :deserialize do
         
        it 'should be okay' do
          obj = SampleDocument.deserialize({:real_name => 'john'})
          obj.name.should == 'john'
        end

      end

      describe :serialize do

        it 'should serialize in both directions' do
          obj = SampleDocument.new
          obj.name = 'john'
          obj.serialize.should == { :name => 'john', :real_name => 'john' }
        end

      end

    end

  end

end
