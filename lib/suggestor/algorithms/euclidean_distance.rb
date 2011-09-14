require_relative 'recommendation_algorithm'

module Suggestor
  module Algorithms
    class EuclideanDistance

      include RecommendationAlgorithm

      def similarity_score_between(first,second)
        return 0 if no_shared_items_between?(first,second)
        inverse_of_sum_of_squares_between(first,second)
      end

    end
  end
end