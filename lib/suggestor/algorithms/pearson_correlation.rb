module Suggestor
  module Algorithms

    # The Pearson Correlation calculates a coefficient
    # between two related items from the main element.

    # For example, if we are dealing with user and movies, related
    # by user reviews of each movie, each couple of users
    # will be used as the axis ("Alvaro" on one, and "Andres" on other)

    # The user movie ratings will be used to position movies on the chart.  
    # Thus, if a "Alvaro" reviews LOTR as 1 and "Andres" with 3, 
    # it will position it on [1,3].

    # A line, "best-fit line", will be traced between all items, showing
    # the closest distance to all of them. If the two users have the same
    # ratings, it would show as a perfect diagonal (score of 1)

    # The closest the movies to the line are, the more similar their tastes 
    # are.

    # The great thing about using Pearson Correlation is that it works with
    # bias to valuating the results. Thus, a user that always rates movies
    # with great scores won't impact and mess up the results.

    # It's probably a best fit for subjetive reviews (movies reviews, profile 
    # points, etc).
    
    # More info at: 
    # http://en.wikipedia.org/wiki/Pearson_product-moment_correlation_coefficient

    class PearsonCorrelation

      include RecommendationAlgorithm

      def similarity_score(first, second)
        return -1.0 if nothing_shared?(first, second)

        process_values(first, second)

        numerator   = difference_from_values
        denominator = square_root_from_differences

        return 0.0 if denominator == 0
        numerator / denominator
      end

      private

      def process_values(first, second)
        items                = shared_items(first, second)
        @total_related_items = items.size.to_f

        first_values  = values_for(first)
        second_values = values_for(second)

        create_helper_variables

        items.each do |item|

          first_value  = first_values[item]
          second_value = second_values[item]

          append_values(first_value, second_value)
          append_squares(first_value, second_value)
          append_product(first_value, second_value)

        end
      end

      def append_values(first_value, second_value)
        @first_values_sum  += first_value
        @second_values_sum += second_value
      end

      def append_squares(first_value, second_value)
        @first_square_values_sum  += ( first_value ** 2 )
        @second_square_values_sum += ( second_value ** 2 )
      end

      def append_product(first_value, second_value)
        @products_sum += first_value * second_value      
      end

      def difference_from_values
        product = @first_values_sum * @second_values_sum
        normalized = product / @total_related_items
        @products_sum - normalized
      end

      def square_root_from_differences
        power_left_result = ( @first_values_sum ** 2 ) / @total_related_items
        equation_left     = @first_square_values_sum - power_left_result

        power_right_result = ( @second_values_sum ** 2 )/ @total_related_items
        equation_right     = @second_square_values_sum - power_right_result

        Math.sqrt( equation_left * equation_right )
      end

      def create_helper_variables
        @first_values_sum         = 0.0
        @second_values_sum        = 0.0
        @first_square_values_sum  = 0.0
        @second_square_values_sum = 0.0
        @products_sum             = 0.0
      end

    end
  end
end