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

    # def execute(method, item, opts)
    #   opts[:algorithm] ||= :euclidean_distance 
    #   strategy_for(opts[:algorithm]).send(method,item, opts[:size])
    # end

    # def strategy_for(algorithm)
    #   constantize(classify(algorithm)).new(collection)
    # end

    # based on Rail's code
    # def classify(name)
    #   name.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }  
    # end

    # def constantize(name)
    #   Suggestor::Algorithms.const_get(name)
    # end
    
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