require 'json'
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

    # def similarity_score_for(first, second, opts={})
    #   run_algorithm_method(:similarity_score_between,first,second)
    # end

    def similar_items_to(item, opts={})
      run_algorithm_method(:similar_items_to,item, opts)
    end

    def recommented_related_items_for(item, opts={})
      run_algorithm_method(:recommented_related_items_for,item, opts)
    end

    def similar_related_items_to(item, opts={})
      run_algorithm_method(:similar_related_items_to,item, opts)
    end

    private

    def run_algorithm_method(method, item, opts)
      opts[:algorithm] ||= :euclidean_distance 
      strategy_for(opts[:algorithm]).send(method,item, opts[:size])
    end

    def strategy_for(algorithm)
      constantize(classify(algorithm)).new(collection)
    end

    # based on Rail's code
    def classify(name)
      name.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }  
    end

    def constantize(name)
      Suggestor::Algorithms.const_get(name)
    end
    
    def add_to_collection(input)
      @collection.merge! parse_from_json(input)
    end

    def parse_from_json(json)
      JSON.parse(json)
    rescue Exception => ex
      raise WrongInputFormat, "Wrong Data format: #{ex.message}" 
    end

  end

end