require 'delegate'

module Suggestor
  module Algorithms
    class Records < DelegateClass(Hash)
      
      def initialize(hash)
        super(hash)
      end

      def remove(item)
        cleaned = self.dup
        cleaned.delete(item)
        cleaned
      end
      
      # changes { "Cat": {"1": 10, "2":20}, "Dog": {"1":5, "2": 15} }
      # to {"1": {"Cat": 10, "Dog": 5}, "2": {"Cat": 20, "Dog": 15}
      def invert
        results = {}

        self.keys.each do |main|
          self[main].keys.each do |item|
            results[item] ||= {}
            results[item][main] = self[main][item]
          end
        end

        results
      end

    end
  end
end