class Corpus < ActiveRecord::Base
    include HasPartsOfSpeech

    attr_reader :text

    def initialize text
        @text = text
    end

    def paragraphs
        @paragraphs ||= data.split(/[\r\n\t]+/)
    end

    def sentences
        @sentences ||= data.strip.split(/[!\?\.]/)
    end

    def words
        @words ||= data.downcase.gsub(/[^\s\w']/, '').split(' ').reject { |w| is_numeric?(w) }
    end

    # As defined by Robert Gunning in the GFI and SMOG
    def complex_words
        @complex_words ||= unique_words.select { |word| syllables_in(word) >= 3 }
    end

    def simple_words
        @simple_words ||= unique_words - complex_words
    end

    def unique_words
        words.map(&:downcase).uniq
    end

    def words_with_syllables syllable_count
        words.select { |word| syllables_in(word) == syllable_count }
    end

    def word_syllables
        words.map(&method(:syllables_in))
    end

    private

    def syllables_in word
        word.downcase.gsub!(/[^a-z]/, '')

        return 1 if word.length <= 3
        return SYLLABLE_COUNT_OVERRIDES[word] if SYLLABLE_COUNT_OVERRIDES.key? word

        word.sub(/(?:[^laeiouy]es|ed|[^laeiouy]e)$/, '').sub!(/^y/, '')
        word.scan(/[aeiouy]{1,2}/).length
    end

    def occurrences of: needles, within: haystack
        of = [of] unless of.is_a? Array

        within.flatten.select { |hay| of.include? hay }.length
    end

end

