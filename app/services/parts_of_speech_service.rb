class PartsOfSpeechService
    extend Service

    def self.acronyms corpus
        corpus.acronyms
    end

    def self.adjectives corpus
        corpus.adjectives.sort
    end

    def self.adverbs corpus
        corpus.adverbs.sort
    end

    def self.auxiliary_verbs corpus
        corpus.words.select { |word| I18n.t('auxillary-verbs').include? word }.uniq.sort
    end

    def self.complex_words corpus
        corpus.complex_words
    end

    def self.conjunctions corpus
        corpus.conjunctions.sort
    end

    def self.determiners corpus
        corpus.determiners.sort
    end

    def self.insert_words corpus
        corpus.words
            .select { |word| I18n.t('insert-words').include? word }
            .uniq
            .sort
    end

    def self.nouns corpus
        corpus.nouns
    end

    def self.numbers corpus
        corpus.numbers
    end

    def self.prepositions corpus
        corpus.prepositions.sort
    end

    def self.pronouns corpus
        corpus.pronouns.sort
    end

    def self.repeated_words corpus
        @repeated_words_metric ||= corpus.words
            .select { |word| corpus.words.rindex(word) != corpus.words.index(word) }
            .uniq
            .sort
    end

    def self.simple_words corpus
        corpus.simple_words
    end

    def self.stem_words corpus
        corpus.words
            .select { |word| word.try(:stem) == word }
            .uniq
            .sort
    end

    def self.stemmed_words corpus
        corpus.words
            .select { |word| word.try(:stem) != word }
            .uniq
            .sort
    end

    def self.stop_words corpus
        corpus.stop_words.uniq.sort
    end

    def self.unique_words corpus
        corpus.unique_words.sort
    end

    def self.unrecognized_words corpus
        corpus.unrecognized_words.sort
    end

    def self.verbs corpus
        corpus.verbs.sort
    end

end