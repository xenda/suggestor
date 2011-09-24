module Suggestor
  module Algorithms    
    module RecommendationAlgorithm

      attr_accessor :collection

      def initialize(collection)
        @collection = collection
      end

      # Ex. Similar users based on their movies reviews
      def similar_to(main, opts={})
        opts.merge!(default_options)
 
        collection = remove_self(main)
        results    = order_by_similarity_score(main,collection)

        sort_results(results,opts[:size])
      end

      # Ex. a user will get movie recommendations
      def recommended_to(main, opts={})
        opts.merge!(default_options)

        @similarities = @totals = Hash.new(0)

        create_similarities_totals(main)
        results = generate_rankings

        sort_results(results,opts[:size])
      end

      # Ex. what other movies are related to a given one
      def similar_related_to(main, opts={})
        opts.merge!(default_options)

        collection = invert_collection
        engine     = self.class.new(collection)
        
        engine.similar_to(main,opts)
      end

      def shared_items(first, second)
        return [] unless values_for(first) && values_for(second)        
         
        related_keys_for(first).select do |item| 
          related_keys_for(second).include? item
        end
      end           

     private

      def default_options
        {size: 5}
      end

      def nothing_shared?(first, second)
        shared_items(first, second).empty?
      end

      def remove_self(main)
        cleaned = collection.dup
        cleaned.delete(main)
        cleaned
      end


      # changes { "Cat": {"1": 10, "2":20}, "Dog": {"1":5, "2": 15} }
      # to {"1": {"Cat": 10, "Dog": 5}, "2": {"Cat": 20, "Dog": 15}
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

      def order_by_similarity_score(main,collection)
        result = collection.keys.inject({}) do |res, other|
          res.merge!({other => similarity_score(main, other)})
        end
      end

      def already_has?(main, related)
        collection[main].has_key?(related)
      end
      
      def values_for(id)
        collection[id.to_s]
      end

      def related_keys_for(id)
        values_for(id).keys
      end
 
      def add_to_totals(other, item, score)
        @totals[item]       += collection[other][item]*score
        @similarities[item] += score
      end

      def sort_results(results,size=-1)
        sorted = results.sort{|a,b| a[1] <=> b[1]}.reverse
        sorted[0, size]
      end

      def generate_rankings
        rankings = {}
        
        @totals.each_pair do |item, total|
          normalized_value = (total / Math.sqrt(@similarities[item]))
          rankings.merge!( { item => normalized_value} )
        end

        rankings
      end

      def something_in_common?(score)
        score > 0
      end

      def same_item?(main, other)
        other == main
      end

      def create_similarities_totals(main)
        
        collection.keys.each do |other|
         
          next if same_item?(main,other)

          score = similarity_score(main, other)

          next unless something_in_common?(score)

          collection[other].keys.each do |item|

            unless already_has?(main, item)
              add_to_totals(other, item, score)            
            end

          end

        end
        
      end


    end
  end
end