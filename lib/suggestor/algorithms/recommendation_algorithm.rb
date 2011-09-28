module Suggestor
  module Algorithms    
    module RecommendationAlgorithm

      attr_accessor :collection

      def initialize(collection)
        @collection = Records.new(collection)
      end

      # Ex. Similar users based on their movies reviews
      def similar_to(main, opts={})
        opts.merge!(default_options)
        
        cleaned = @collection.remove(main)

        results = order_by_similarity_score(main, cleaned)

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

        inverted_collection = @collection.invert
        suggestor     = self.class.new(inverted_collection)
        
        suggestor.similar_to(main,opts)
      end

     private

      def default_options
        {size: 5}
      end

      def order_by_similarity_score(main, collection)
        result = collection.keys.inject({}) do |res, other|
          res.merge!({other => similarity_score(main, other)})
        end
      end
      
      def add_to_totals(other, item, score)
        @totals[item]       += @collection[other][item] * score
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

      def create_similarities_totals(main)
        
        @collection.keys.each do |other|
         
          next if other == main

          score = similarity_score(main, other)

          next unless something_in_common?(score)

          @collection[other].keys.each do |item|

            unless @collection.already_has?(main, item)
              add_to_totals(other, item, score)            
            end

          end

        end
        
      end


    end
  end
end