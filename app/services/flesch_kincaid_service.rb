class FleschKincaidService
    extend Service

    def self.grade_level corpus
        [
            0.38 * (corpus.words.length.to_f / corpus.sentences.length),
            11.18 * (corpus.word_syllables.sum.to_f / corpus.words.length),
            -15.59
        ].sum
    end

end