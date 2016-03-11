class FleschKincaidService
    extend Service

    def self.grade_level corpus
        [
            0.38 * (corpus.words.length.to_f / corpus.sentences.length),
            11.18 * (corpus.word_syllables.sum.to_f / corpus.words.length),
            -15.59
        ].sum
    end

    def self.age_minimum corpus
        @flesch_kincaid_age_minimum ||= case reading_ease(corpus)
            when (90..100) then 11
            when (71..89)  then 12
            when (67..69)  then 13
            when (64..66)  then 14
            when (60..63)  then 15
            when (50..59)  then 18
            when (40..49)  then 21
            when (31..39)  then 24
            when (0..30)   then 25
            else 2
        end
    end

    def self.reading_ease corpus
        @flesch_kincaid_reading_ease ||= [
            206.835,
            -(1.015 * corpus.words.length.to_f / corpus.sentences.length),
            -(84.6 * corpus.word_syllables.sum.to_f / corpus.words.length)
        ].sum
    end

end