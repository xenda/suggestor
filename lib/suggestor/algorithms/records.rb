require 'delegate'

module Suggestor
  module Algorithms
    class Records < DelegateClass(Hash)
      
      def initialize(hash)
        super(hash)
      end

      def dup
        Marshal.load(Marshal.dump(self))
      end

      def remove(item)
        cleaned = self.dup
        cleaned.delete(item)
        cleaned
      end

      def common_items(first, other)
        values_for(first) && values_for(other)
      end

      def already_has?(main, related)
        self[main].has_key?(related)
      end
      
      def values_for(id)
        self[id.to_s]
      end

      def related_keys_for(id)
        values_for(id).keys
      end

      def shared_items(first, other)
        return [] unless common_items(first, other)
         
        related_keys_for(first).select do |item| 
          related_keys_for(other).include? item
        end
      end           

      def nothing_shared?(first, second)
        shared_items(first, second).empty?
      end

      def inverse_of_squares(first, second)
        1/(1+Math.sqrt(sum_squares(first, second)))
      end

      def sum_squares(first, second)
        shared_items(first, second).inject(0.0) do |sum, item|
          sum + ( values_for(first)[item] - values_for(second)[item] ) ** 2
        end
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

      def order_by_similarity(main,scores_between)
        result = self.keys.inject({}) do |res, other|
          res.merge!({other => scores_between(main, other)})
        end
      end

    end
  end
end