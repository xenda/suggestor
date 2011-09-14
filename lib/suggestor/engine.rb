require 'JSON'
require_relative 'datum'
require_relative 'algorithms/recommendation_algorithm'
require_relative 'algorithms/euclidean_distance'
require_relative 'algorithms/pearson_correlation'

module Suggestor

  class WrongInputFormat < Exception; end

  class Engine

    attr_accessor :collection

    def initialize
      @collection = {}
    end

    def load_data(input)
      add_to_collection(input)
    end

    def similarity_score_for(first,second,algorithm)
      strategy_for(algorithm).similarity_score_between(first,second)
    end

    def similar_items_to(item,algorithm)
      strategy_for(algorithm).similar_items_to(item)
    end

    def recommented_related_items_for(item,algorithm)
      strategy_for(algorithm).recommented_related_items_for(item)
    end

    private

    def strategy_for(algorithm)
      constantize(classify(algorithm)).new(collection)
    end

    # based on Rail's code
    def classify(name)
      name.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }  
    end

    def constantize(name)
      Object.const_get("Suggestor").const_get("Algorithms").const_get(name)
    end
    
    def add_to_collection(input)
      @collection.merge! parse_from_json(input)
    end

    def parse_from_json(json)
      # Datum.new(JSON.parse(json))
      JSON.parse(json)
    rescue Exception => ex
      raise WrongInputFormat, "Wrong Data format: #{ex.message}" 
    end

  end

end