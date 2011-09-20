require 'minitest/autorun'
require_relative '../lib/suggestor'

  describe Suggestor::Engine do
    before do
      @suggestor = Suggestor::Engine.new
      @data_string = File.read("test/numbers.json")
    end

    describe "when loading up the data structure" do
      it "must raise an exception with invalid data" do
        lambda{ @suggestor.load_data("GIBBERISH}") }.must_raise Suggestor::WrongInputFormat
      end

      it "must return an array structure if data is ok" do
        @suggestor.load_data(@data_string).must_be_instance_of Hash
      end

    end

    describe "when accesing the data after load_dataing it" do

      before do
        @suggestor.load_data(@data_string)
      end

      it "must return similar items from the base one with euclidean distance" do
        expected = [["3", 0.14285714285714285], ["2", 0.14285714285714285]]
        @suggestor.similar_items_to("1").must_be :==, expected
      end

      it "must return similar items from the base one with pearson correlation" do
        expected = [["2", 0.0], ["1", 0.0]]
        opts = {algorithm: :pearson_correlation}
        @suggestor.similar_items_to("3",opts).must_be :==, expected
      end

      it "must return similar items from the base one with euclidean distance" do
        expected = [["4", 2.6457513110645903]]
        @suggestor.recommented_related_items_for("2").must_be :==, expected
      end

      it "must return similar related items from one of them" do
        expected = [["3", 1.0], ["1", 0.14285714285714285]]
        @suggestor.similar_items_to("2").must_be :==, expected
      end


    end

  end