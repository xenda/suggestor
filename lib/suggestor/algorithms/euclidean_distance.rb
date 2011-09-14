require_relative 'recommendation_algorithm'

module Suggestor
  module Algorithms
    class EuclideanDistance

      include RecommendationAlgorithm

      def similarity_score_between(first, second)
        return 0.0 if no_shared_items_between?(first, second)
        inverse_of_sum_of_squares_between(first, second)
      end

      def inverse_of_sum_of_squares_between(first, second)
        1/(1+sum_squares_of_shared_items_between(first, second))
      end

      def sum_squares_of_shared_items_between(first, second)
        shared_items_between(first, second).inject(0.0) do |sum, item|
          sum + (values_for(first)[item] - values_for(second)[item])**2
        end
      end

    end
  end
end