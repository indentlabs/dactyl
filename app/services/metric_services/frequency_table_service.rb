class FrequencyTableService
    extend Service

    def self.word_frequency_table corpus
        table = corpus.words.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
        table.reject! { |k, v| v == 1 } if table.any? { |k, v| v > 1 } && table.length > 50
        table = Hash[table.sort_by { |k, v| v }.reverse]
        table
    end

end