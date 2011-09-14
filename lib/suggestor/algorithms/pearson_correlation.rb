require_relative 'recommendation_algorithm'

module Suggestor
  module Algorithms
    class PearsonCorrelation

      include RecommendationAlgorithm

      def similarity_score_between(first,second)
        return 0.0 if no_shared_items_between?(first,second)
        shared_items = shared_items_between(first,second)
        total_related_items = shared_items.size

        first_values_sum = second_values_sum =
        first_square_values_sum = second_square_values_sum = items_sum = 0.0

        shared_items.each do |item|

          # Will add all the related items values  for the first
          # and second item
          # For ex., all movie recommendations ratings
          first_values_sum += values_for(first)[item]
          second_values_sum += values_for(second)[item]

          # Adds the squares of both elements
          first_square_values_sum += values_for(first)[item] ** 2
          second_square_values_sum += values_for(second)[item] ** 2

          # Adds all the average of both elements
          items_sum += values_for(first)[item]*values_for(second)[item]

        end

        numerator = items_sum - (first_values_sum*second_values_sum/total_related_items)
        denominator = Math.sqrt((first_square_values_sum - first_values_sum**2/total_related_items) * (
        second_square_values_sum-second_values_sum**2/total_related_items))
        return 0.0 if denominator == 0
        t = numerator / denominator
        puts t.inspect
        t

      end
    end
  end
end