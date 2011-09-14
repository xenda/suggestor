require_relative 'recommendation_algorithm'

module Suggestor
  module Algorithms
    class PearsonCorrelation

      include RecommendationAlgorithm

      def similarity_score_between(first, second)
        return 0.0 if no_shared_items_between?(first, second)

        calculate_all_sums_for(first, second)
        numerator = difference_from_total_and_normalize_values
        # 10.5 /    0.0 / 
        denominator = square_root_from_differences_of_sums

        return 0.0 if denominator == 0

        numerator / denominator

      end

      private

      def calculate_all_sums_for(first,second)
        
        shared_items = shared_items_between(first, second)
        @total_related_items = shared_items.size

        #simplify access
        first_values = values_for(first)
        second_values = values_for(second)

        @first_values_sum = @second_values_sum = @first_square_values_sum = \
        @second_square_values_sum = @products_sum = 0.0

        shared_items.each do |item|

          # Gets the corresponding value for each item on both elements
          # For ex., the rating of the same movie by different users
          first_value = first_values[item]
          second_value = second_values[item]

          # Will add all the related items values  for the first
          # and second item
          # For ex., all movie recommendations ratings
          @first_values_sum += first_value
          @second_values_sum += second_value

          # Adds the squares of both elements
          @first_square_values_sum += first_value ** 2
          @second_square_values_sum += second_value ** 2

          # Adds the product of both values
          @products_sum += first_value*second_value
        end

      end

      def difference_from_total_and_normalize_values
        product = @first_values_sum * @second_values_sum
        normalized = product / @total_related_items
        @products_sum - normalized
      end

      def square_root_from_differences_of_sums
        
        power_left_result = @first_values_sum **2 /@total_related_items
        equation_left = @first_square_values_sum - power_left_result

        power_right_result = ( @second_values_sum **2 )/@total_related_items
        equation_right = @second_square_values_sum - power_right_result
        Math.sqrt(equation_left * equation_right)

      end

    end
  end
end