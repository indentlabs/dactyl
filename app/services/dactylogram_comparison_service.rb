class DactylogramComparisonService
    extend Service

    def self.most_similar_author dactylogram
        raise "not implemented"

        authors = Dactylogram.all.select {|d| d.identifier.start_with? 'authors/' }
        return if authors.empty?

        most_similar_author = authors.first
        shortest_distance = distance_to most_similar_author

        authors.drop(1).each do |author|
           if distance_to(author) < shortest_distance
               shortest_distance = distance_to author
               most_similar_author = author
           end
        end

        most_similar_author.identifier
    end

    #n-dimensional cartesian distance on shared metrics
    def self.distance from:, to:
        raise "not implemented"

        shared_metrics = from.metrics.keys & to.metrics.keys
        distance = shared_metrics.map do |metric|
            if metric.class == Fixnum || metric.class == Float
                (metrics[metric] - to.metrics[metric]).abs
            else
                0
            end
        end.sum
    end

end