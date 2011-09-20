module Suggestor
  module Algorithms    
    module RecommendationAlgorithm

      attr_accessor :collection

      def initialize(collection)
        @collection = collection
      end

      # returns similar items based on their similary score
      # for example, similar users based on their movies reviews
      def similar_items_to(main, size=nil)

        #just compare those whore aren't the main item
        compare_to = collection.dup
        compare_to.delete(main)

        # return results based on their score
        result = compare_to.keys.inject({}) do |res, other|
          res.merge!({other => similarity_score_between(main, other)})
        end

        sorted_result = sort_results(result)
        return sorted_result[0, size] if size
        sorted_result

      end

      # returns recommended related items for the main user
      # The most important feature. For example, a user will get
      # movie recommendations based on his past movie reviews
      # and how it compares with others
      def recommented_related_items_for(main, size=nil)

        @similarities = @totals = Hash.new(0)
        @main = main

        create_similarities_totals
        generate_rankings(size)

      end

      # returns similar related items from the original
      # collection. For example, it will say what other movies
      # are related to a given one. Inverts the user data
      def similar_related_items_to(main,size=nil)
        collection = invert_collection

        engine = self.class.new(collection)
        engine.similar_items_to(main,size)
      end

      # will invert the collection
      # returning { "Cat": {"1": 10, "2":20}, "Dog": {"1":5, "2": 15} }
      # from {"1": {"Cat": 10, "Dog": 5}, "2": {"Cat": 20, "Dog": 15}

      def invert_collection
        results = {}

        collection.keys.each do |main|
          collection[main].keys.each do |item|
            results[item] ||= {}
            results[item][main] = collection[main][item]
          end
        end

        results
      end

      def no_shared_items_between?(first, second)
        shared_items_between(first, second).empty?
      end

      def shared_items_between(first, second)
        return [] unless values_for(first) && values_for(second)         
        related_keys_for(first).select do |item| 
          related_keys_for(second).include? item
        end
      end

     private

      def main_already_has?(related)
        collection[@main].has_key?(related)
      end
      
      def values_for(id)
        collection[id.to_s]
      end

      def related_keys_for(id)
        values_for(id).keys
      end
 
      def add_to_totals(other, item, score)
        @totals[item] += collection[other][item]*score
        @similarities[item] += score
      end

      def sort_results(results)
        results.sort{|a,b| a[1] <=> b[1]}.reverse
      end

      def generate_rankings(size=nil)
        rankings = {}
        
        @totals.each_pair do |item, total|
          normalized_value = (total / Math.sqrt(@similarities[item]))
          rankings.merge!( { item => normalized_value} )
        end
        sorted_rankings = sort_results(rankings)
        
        return sorted_rankings[0, size] if size
        sorted_rankings
      end

      def create_similarities_totals
        
        collection.keys.each do |other|
         
          # won't bother comparing it if the compared item is the same
          # as the main, or if they scores are below 0 (nothing in common)
          next if other == @main
          score = similarity_score_between(@main, other)
          next if score <= 0

          # will compare each the results but only for related items
          # that the main item doesn't already have
          # For ex., if they have already saw a movie they won't 
          # get it suggested 
          collection[other].keys.each do |item|

            unless main_already_has?(item)
              add_to_totals(other, item, score)            
            end

          end

        end
        
      end

    end
  end
end