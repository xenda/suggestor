require 'minitest/autorun'
require_relative '../lib/suggestor'

  describe Suggestor::Algorithms::PearsonCorrelation do
    
    before do
      data_string = File.read("test/numbers.json")
      
      suggestor = Suggestor::Engine.new(data_string)
      @algorithm = Suggestor::Algorithms::PearsonCorrelation.new(suggestor.collection)
    end

    describe "when building up recommendations" do

      it "must return a list of shared items between two people" do 
        @algorithm.shared_items(1,2).must_be :==, ["1","2"]
      end

      it "must return 1 as similarity record if two elements have equal related values" do 
        @algorithm.similarity_score(1,1).must_be :==, 1
      end

      it "must return -1 as similarity record if two elements are totally distant" do 
        @algorithm.similarity_score(1,99).must_be :==, -1
      end


    end
  end