require 'json'

module Suggestor

  class WrongInputFormat < Exception; end

  class Engine

    attr_accessor :collection, :algorithm

    def initialize(input, algorithm=Algorithms::EuclideanDistance)
      @collection = parse_from_json(input)
      @algorithm = algorithm.new(@collection)
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

    private
    
    def parse_from_json(json)
      JSON.parse(json)
    rescue Exception => ex
      raise WrongInputFormat, "Wrong Data format: #{ex.message}" 
    end

  end

end