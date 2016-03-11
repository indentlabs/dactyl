class ReadabilityService
    extend Service

    def self.combined_average_grade_level corpus
        scores = [
            automated_readability_index(corpus),
            coleman_liau_index(corpus),
            FleschKincaidService.grade_level(corpus),
            forcast_grade_level(corpus),
            gunning_fog_index(corpus),
            smog_grade(corpus)
        ]
        scores.reject! &:nan?
        scores.reject! { |hasselhoff| hasselhoff.abs == Float::INFINITY }

        return unless scores.length > 2

        scores.sort.slice(1..-2).sum.to_f / 4
    end

    def self.flesch_kincaid_grade_level corpus
        FleschKincaidService.grade_level corpus
    end

    def self.flesch_kincaid_age_minimum corpus
        FleschKincaidService.age_minimum corpus
    end

    def self.flesch_kincaid_reading_ease corpus
        FleschKincaidService.reading_ease corpus
    end

    def self.forcast_grade_level corpus
        @forcast_grade_level ||= 20 - (((corpus.words_with_syllables(1).length.to_f / corpus.words.length) * 150) / 10.0)
    end

    def self.coleman_liau_index corpus
        @coleman_liau_index ||= [
            0.0588 * 100 * corpus.characters.length.to_f / corpus.words.length,
            -0.296 * 100 / (corpus.words.length.to_f / corpus.sentences.length),
            -15.8
        ].sum
    end

    def self.automated_readability_index corpus
        @automated_readability_index ||= [
            4.71 * corpus.characters.reject(&:blank?).length.to_f / corpus.words.length,
            0.5 * corpus.words.length.to_f / corpus.sentences.length,
            -21.43
        ].sum
    end

    def self.gunning_fog_index corpus
        #todo GFI word/suffix exclusions
        @gunning_fog_index ||= 0.4 * (corpus.words.length.to_f / corpus.sentences.length + 100 * (corpus.complex_words.length.to_f / corpus.words.length))
    end

    def self.smog_grade corpus
        @smog_grade ||= 1.043 * Math.sqrt(corpus.complex_words.length.to_f * (30.0 / corpus.sentences.length)) + 3.1291
    end

end