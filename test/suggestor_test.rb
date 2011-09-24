require 'minitest/autorun'
require_relative '../lib/suggestor'

  describe Suggestor::Engine do
    before do
      @data_string = File.read("test/numbers.json")
    end

    describe "when loading up the data structure" do
      it "must raise an exception with invalid data" do
        lambda{ Suggestor::Engine.new("GIBBERISH") }.must_raise Suggestor::WrongInputFormat
      end
    end

    describe "when accesing the data after load_dataing it" do

      before do
        @suggestor = Suggestor::Engine.new(@data_string)
      end

      it "must return similar items from the base one with euclidean distance" do
        expected = [["3", 0.14285714285714285], ["2", 0.14285714285714285]]
        @suggestor.similar_to("1").must_be :==, expected
      end

      it "must return similar items from the base one with pearson correlation" do
        @suggestor = Suggestor::Engine.new(@data_string,Suggestor::Algorithms::PearsonCorrelation)
        expected = [["2", 0.0], ["1", 0.0]]
        @suggestor.similar_to("3").must_be :==, expected
      end

      it "must return similar items from the base one with euclidean distance" do
        expected = [["4", 2.6457513110645903]]
        @suggestor.recommended_to("2").must_be :==, expected
      end

      it "must return similar related items from one of them" do
        expected = [["5", 0.3333333333333333], ["3", 0.25], ["1", 0.12389934309929541], ["4", 0.0]]
        @suggestor.similar_related_to("2").must_be :==, expected
      end

    end
  end