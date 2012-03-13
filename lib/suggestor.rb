require_relative 'suggestor/algorithms/records'
require_relative 'suggestor/algorithms/recommendation_algorithm'
require_relative 'suggestor/algorithms/euclidean_distance'
require_relative 'suggestor/algorithms/pearson_correlation'

require 'json'
module Suggestor
  class WrongInputFormat < Exception; end
  
  class Suggestor

    def initialize(input, algorithm = Algorithms::EuclideanDistance)
      collection = parse_from_json(input)
      @algorithm  = algorithm.new(collection)
    end

    def similar_to(item, opts={})
      @algorithm.similar_to(item, opts)
    end

    def recommended_to(item, opts={})
      @algorithm.recommended_to(item, opts)
    end

    def similar_related_to(item, opts={})
      @algorithm.similar_related_to(item, opts)
    end

    def items_for_set(set, opts={})
      @algorithm.items_for_set(set, opts)
    end

    private

    def parse_from_json(json)
      JSON.parse(json)
    rescue Exception => ex
      raise WrongInputFormat, "Wrong Data format: #{ex.message}" 
    end

  end
end
