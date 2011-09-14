module Suggestor
  module Algorithms    
    module RecommendationAlgorithm

      attr_accessor :collection

      def initialize(collection)
        @collection = collection
      end

      def similar_items_to(item)
        compare_to = collection.dup
        compare_to.delete(item)
        compare_to.keys.inject({}) do |result, other|
          result.merge!({other => similarity_score_between(item,other)})
        end
      end

      def recommented_related_items_for(item)
        totals = {}
        sum = {}
        collection.each do |other|
          next if other == item
          score = similarity_score_between(item,other)
          next if score <= 0

          collection[other].each do |other_item|
            unless collection[item].incluude? other_item || collection[item][]
            end
          end

        end

      end

      def inverse_of_sum_of_squares_between(first,second)
        1/(1+sum_squares_of_shared_items_between(first,second))
      end

      def sum_squares_of_shared_items_between(first,second)
        shared_items_between(first,second).inject(0.0) do |sum,item|
          sum + (values_for(first)[item] - values_for(second)[item])**2
        end
      end

      def no_shared_items_between?(first,second)
        shared_items_between(first,second).empty?
      end

      def shared_items_between(first,second)
        return [] unless values_for(first) && values_for(second)         
        related_keys_for(first).select do |item| 
          related_keys_for(second).include? item
        end
      end

      def values_for(id)
        collection[id.to_s]
      end

      def related_keys_for(id)
        values_for(id).keys
      end

    end
  end
end