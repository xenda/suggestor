require 'minitest/autorun'
require_relative '../lib/suggestor/algorithms/pearson_correlation'
require_relative '../lib/suggestor/engine'

  describe Suggestor::Algorithms::PearsonCorrelation do
    
    before do
      @data_string = File.read("test/test.json")
      @suggestor = Suggestor::Engine.new
      @suggestor.load_data(@data_string)
      @algorithm = Suggestor::Algorithms::PearsonCorrelation.new(@suggestor.collection)
    end

    describe "when building up recommendations" do

      it "must return a list of shared items between two people" do 
        @algorithm.shared_items_between(1,2).must_be :==, ["1","2"]
      end

      it "must return 0 as similarity record if two elements hace no shared items" do 
        @algorithm.similarity_score_between(1,4).must_be :==, 0
      end

      it "must return 1 as similarity record if two elements have equal related values" do 
        @algorithm.similarity_score_between(1,1).must_be :==, 1
      end

      it "must return -1 as similarity record if two elements are totally distant" do 
        @algorithm.similarity_score_between(1,99).must_be :==, 0
      end


    end
  end