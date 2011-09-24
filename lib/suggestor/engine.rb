require 'json'

module Suggestor

  class WrongInputFormat < Exception; end

  class Engine

    attr_accessor :collection, :algorithm_class, :algorithm

    def initialize(algorithm=nil)
      @collection = {}
      algorithm ||= Suggestor::Algorithms::EuclideanDistance
      @algorithm_class = algorithm
    end

    def load_data(input)
      add_to_collection(input)
      initialize_algorithm
      collection
    end
    
    def similar_to(item, opts={})
      algorithm.similar_to(item, opts)
    end

    def recommended_to(item, opts={})
      algorithm.recommended_to(item, opts)
    end

    def similar_related_to(item, opts={})
      algorithm.similar_related_to(item, opts)
    end

    private
    
    def add_to_collection(input)
      @collection.merge! parse_from_json(input)
    end

    def parse_from_json(json)
      JSON.parse(json)
    rescue Exception => ex
      raise WrongInputFormat, "Wrong Data format: #{ex.message}" 
    end

    def initialize_algorithm
      @algorithm = @algorithm_class.new(collection)
    end

  end

end