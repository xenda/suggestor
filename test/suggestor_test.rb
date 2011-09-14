require 'minitest/autorun'
require_relative '../lib/suggestor'

  describe Suggestor::Engine do
    before do
      @suggestor = Suggestor::Engine.new
      @data_string = File.read("test/test.json")
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

      it "must return a similarty score between to elements" do
        @suggestor.similarity_score_for("1","1",:euclidean_distance).must_be :==, 1
      end

      it "must return similar items from the base one" do
        expected = {"1"=>0.058823529411764705, "3"=>0.038461538461538464} 
        @suggestor.similar_items_to("2",:euclidean_distance).must_be :==, expected
      end


      it "must return similar items from the base one" do
        expected = {"1"=>0.058823529411764705, "3"=>0.038461538461538464} 
        @suggestor.similar_items_to("1",:pearson_correlation).must_be :==, expected
      end

      # it "must return equal similarty records if both are equal" do
      #   users = {users: [{id:1, values:[{movie_id:1,value:10},{movie_id:2,value:3}]}]}
      #   @suggestor.user_collection.must_be_same_as users
      # end

    end

  end