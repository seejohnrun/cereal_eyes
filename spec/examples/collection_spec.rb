require File.dirname(__FILE__) + '/../spec_helper'

describe CerealEyes do

  before :each do
    Object.send :remove_const, :SampleDocument if defined?(SampleDocument)
  end

  describe 'should work with enumerables' do

    before :each do
      class SampleDocument
        include CerealEyes::Document
        attribute :documents, :type => self
        attribute :name
      end
    end

    describe :deserialize do

      it 'should be able to deserialize a collection of a type' do
        doc = SampleDocument.deserialize(:documents => [{:name => 'one'}, {:name => 'two'}]) 
        doc.documents.each { |d| d.should be_a(SampleDocument) }
        doc.documents.map(&:name).should == ['one', 'two']
      end

    end

    describe :serialize do

      it 'should be able to serialize a collection of a type' do
        doc = SampleDocument.new
        doc.documents = []
        n1 = SampleDocument.new; n1.name = 'one'; doc.documents << n1
        n2 = SampleDocument.new; n2.name = 'two'; doc.documents << n2
        doc.serialize.should == { :documents => [ { :name => 'one' }, { :name => 'two' } ] }

      end

    end

  end

end
