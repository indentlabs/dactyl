class WordFrequencyService
    extend Service

    def self.acronyms_percentage corpus
        corpus.acronyms.length.to_f / corpus.words.length
    end


    def self.adjective_percentage corpus
        corpus.adjectives.length.to_f / corpus.words.length
    end

    def self.auxiliary_verbs_percentage corpus
        PartsOfSpeechService.auxiliary_verbs(corpus).length.to_f / corpus.words.length
    end

    def self.character_count corpus
        corpus.text.length
    end

    def self.characters_per_paragraph corpus
        return unless corpus.paragraphs.length > 1
        corpus.characters.length.to_f / corpus.paragraphs.length
    end

    def self.characters_per_sentence corpus
        corpus.text.length.to_f / corpus.sentences.length
    end

    def self.characters_per_word corpus
        corpus.words.map(&:length).sum.to_f / corpus.words.length
    end

    def self.conjunction_percentage corpus
        corpus.words.select { |word| I18n.t('conjunctions').include? word }.length.to_f / corpus.words.length
    end

    def self.consonants_per_word_percentage corpus
        squished_characters = corpus.words.join('')
        squished_characters.scan(/[^aeiou]/).length.to_f / squished_characters.length
    end

    def self.digits_per_word corpus
        squished_characters = corpus.words.join('')
        squished_characters.scan(/[0-9]/).length.to_f / squished_characters.length
    end

    def self.determiner_percentage corpus
        corpus.words.select { |word| I18n.t('determiners').include? word }.length.to_f / corpus.words.length
    end

    def self.most_frequent_word corpus
        (FrequencyTableService.word_frequency_table(corpus).max_by { |k, v| v } || corpus.words).first
    end

    def self.noun_percentage corpus
        corpus.nouns.length.to_f / corpus.words.length
    end

    def self.numbers_percentage corpus
        corpus.numbers.length.to_f / (corpus.words.length + corpus.numbers.length).to_f
    end

    def self.preposition_percentage corpus
        corpus.words.select { |word| I18n.t('prepositions').include? word }.length.to_f / corpus.words.length
    end

    def self.pronoun_percentage corpus
        corpus.pronouns.length.to_f / corpus.words.length
    end

    def self.punctuation_percentage corpus
        corpus.text.scan(/[\.,;\?!\-"':\(\)\[\]"]/).length.to_f / corpus.characters.length
    end

    def self.repeated_word_percentage corpus
        PartsOfSpeechService.repeated_words(corpus).length.to_f / corpus.words.length
    end

    def self.sentence_count corpus
        corpus.sentences.length
    end

    def self.sentences_per_paragraph corpus
        return unless corpus.paragraphs.length > 1
        corpus.sentences.length.to_f / corpus.paragraphs.length
    end

    def self.spaces_after_sentence corpus
        spaces_per_sentence = corpus.sentences.map { |sentence|
            sentence.length - sentence.gsub(/^ +/, '').length
        }.reject(&:zero?)

        spaces = spaces_per_sentence.sum.to_f / spaces_per_sentence.length
        spaces = 0 if spaces.nan?
        spaces
    end

    def self.special_character_percentage corpus
        corpus.text.scan(/[\$\^#@%~]/).length.to_f / corpus.characters.length
    end

    def self.syllable_count corpus
        corpus.word_syllables.sum
    end

    def self.syllables_per_sentence corpus
        total_syllables = 0
        corpus.sentences.each do |sentence|
            total_syllables += sentence.split(' ')
                .map { |word| corpus.syllables_in(word) }
                .sum
        end

        total_syllables.to_f / corpus.sentences.length
    end

    def self.syllables_per_word corpus
        corpus.word_syllables.sum.to_f / corpus.words.length
    end

    def self.unique_words_per_paragraph corpus
        return unless corpus.paragraphs.length > 1
        corpus.unique_words.length.to_f / corpus.paragraphs.length
    end

    def self.unique_words_per_paragraph_percentage corpus
        return unless corpus.paragraphs.length > 1
        unique_words_per_paragraph(corpus).to_f / words_per_paragraph(corpus)
    end

    def self.unique_words_per_sentence corpus
        corpus.unique_words.length.to_f / corpus.sentences.length
    end

    def self.unique_words_per_sentence_percentage corpus
        unique_words_per_sentence(corpus) / words_per_sentence(corpus)
    end

    def self.unique_words_percentage corpus
        corpus.unique_words.length.to_f / corpus.words.length
    end

    def self.verb_percentage corpus
        corpus.verbs.length.to_f / corpus.words.length
    end

    def self.vowels_per_word_percentage corpus
        squished_characters = corpus.words.join('')
        squished_characters.scan(/[aeiou]/).length.to_f / squished_characters.length
    end

    def self.whitespace_percentage corpus
        occurrences(of: ["\s", "\r", "\n", "\t"], within: corpus.characters).to_f / corpus.text.length
    end

    def self.word_count corpus
        corpus.words.length
    end

    def self.words_per_paragraph corpus
        return unless corpus.paragraphs.length > 1
        corpus.words.length.to_f / corpus.paragraphs.length
    end

    def self.words_per_sentence corpus
        corpus.words.length.to_f / corpus.sentences.length
    end

    private


    def self.occurrences of: needles, within: haystack
        of = [of] unless of.is_a? Array

        within.flatten.select { |hay| of.include? hay }.length
    end

end