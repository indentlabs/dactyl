class Dactylogram < ActiveRecord::Base
    attr_accessor :data

    validates :data, presence: true

    PREPOSITIONS = ["about", "across", "against", "along", "around", "at", "behind",
        "beside", "besides", "by", "despite", "down", "during", "for", "from", "in",
        "inside", "into", "near", "of", "off", "on", "onto", "over", "through", "to",
        "toward", "with", "within", "without"]

    PRONOUNS = ["i", "you", "he", "me", "her", "him", "my", "mine", "her",
        "hers", "his", "myself", "himself", "herself", "anything",
        "everything", "anyone", "everyone", "ones", "such", "it",
        "we", "they", "us", "them", "our", "ours", "their", "theirs",
        "itself", "ourselves", "themselves", "something", "nothing", "someone"]

    DETERMINERS = ["the", "some", "this", "that", "every", "all", "both", "one",
        "first", "other", "next", "many", "much", "more", "most",
        "several", "no", "a", "an", "any", "each", "half", "twice",
        "two", "second", "another", "last", "few", "little", "less",
        "least", "own"]

    CONJUNCTIONS =  ["and", "but", "after", "when", "as", "because", "if", "what",
        "which", "how", "than", "or", "so", "before", "since", "while", "where",
        "although", "though", "who", "whose"]

    SYLLABLE_COUNT_OVERRIDES = {
        'ion' => 2
    }

    def metric_report
        {
            original_string: data,
            metrics: calculate_metrics
        }
    end

    def all_metrics
        self.class.instance_methods.select { |m| metric? m }
    end

    def automated_readability_index_metric
        [
            4.71 * data.chars.reject(&:blank?).length.to_f / words.length,
            0.5 * words.length.to_f / sentences.length,
            -21.43
        ].sum
    end

    def characters_per_paragraph_metric
        data.chars.length.to_f / paragraphs.length
    end

    def characters_per_sentence_metric
        data.length.to_f / sentences.length
    end

    def characters_per_word_metric
        words.map(&:length).sum.to_f / words.length
    end

    def coleman_liau_index_metric
        [
            0.0588 * 100 * data.chars.length.to_f / words.length,
            -0.296 * 100 / (words.length.to_f / sentences.length),
            -15.8
        ].sum
    end

    def combined_average_grade_level_metric
        [
            automated_readability_index_metric,
            coleman_liau_index_metric,
            flesch_kincaid_grade_level_metric,
            forcast_grade_level_metric,
            gunning_fog_index_metric,
            smog_grade_metric
        ].sum.to_f / 6
    end

    def conjunction_frequency_metric
        words.select { |word| CONJUNCTIONS.include? word }.length.to_f / words.length
    end

    def consonants_per_word_metric
        squished_characters = words.join('')
        squished_characters.scan(/[^aeiou]/).length.to_f / squished_characters.length
    end

    def consonants_per_word_percentage_metric
        squished_characters = words.join('')
        squished_characters.scan(/[^aeiou]/).length.to_f / squished_characters.length
    end

    def data_length_metric
        data.length
    end

    def digits_per_word_metric
        squished_characters = words.join('')
        squished_characters.scan(/[0-9]/).length.to_f / squished_characters.length
    end

    def determiner_frequency_percentage_metric
        words.select { |word| DETERMINERS.include? word }.length.to_f / words.length
    end

    def flesch_kincaid_age_minimum_metric
        case flesch_kincaid_reading_ease_metric
            when (90..100) then 11
            when (71..89)  then 12
            when (67..69)  then 13
            when (64..66)  then 14
            when (60..63)  then 15
            when (50..59)  then 18
            when (40..49)  then 21
            when (31..39)  then 24
            when (0..30)   then 25
            else "N/A"
        end
    end

    def flesch_kincaid_grade_level_metric
        [
            0.38 * (words.length.to_f / sentences.length),
            11.18 * (word_syllables.sum.to_f / words.length),
            -15.59
        ].sum
    end

    def flesch_kincaid_reading_ease_metric
        [
            206.835,
            -(1.015 * words.length.to_f / sentences.length),
            -(84.6 * word_syllables.sum.to_f / words.length)
        ].sum
    end

    def forcast_grade_level_metric
        20 - (words_with_syllables(1).length.to_f / words.length / 10)
    end

    def gunning_fog_index_metric
        #todo GFI word/suffix exclusions
        0.4 * (words.length.to_f / sentences.length + 100 * (complex_words.length.to_f / words.length))
    end

    def letters_per_word_metric
        data.chars.length.to_f / words.length
    end

    def most_frequent_word_metric
        word_frequency_table_metric.max_by { |k, v| v }.first
    end

    def paragraphs_metric
        paragraphs.length
    end

    def preposition_frequency_metric
        words.select { |word| PREPOSITIONS.include? word }.length.to_f / words.length
    end

    def pronoun_frequency_metric
        words.select { |word| PRONOUNS.include? word }.length.to_f / words.length
    end

    def punctuation_percentage_metric
        data.scan(/[\.,;\?!\-"':\(\)\[\]"]/).length.to_f / data.chars.length
    end

    def repeated_words_metric
        words.select {|e| words.rindex(e) != words.index(e) }.uniq
    end

    def repeated_word_percentage_metric
        repeated_words_metric.length.to_f / words.length
    end

    def sentence_count_metric
        sentences.length
    end

    def sentences_metric
        sentences
    end

    def sentences_per_paragraph_metric
        sentences.length.to_f / paragraphs.length
    end

    def sentiment_metric
        "not implemented"
    end

    def smog_grade_metric
        1.043 * Math.sqrt(complex_words.length.to_f * (30.0 / sentences.length)) + 3.1291
    end

    def spaces_after_sentence_metric
        spaces_per_sentence = sentences.map { |sentence|
            sentence.length - sentence.lstrip.length
        }.sum.to_f / (sentences.length - 1)
    end

    def special_character_percentage_metric
        data.scan(/[\$\^#@%~]/).length.to_f / data.chars.length
    end

    def syllable_count_metric
        word_syllables.sum
    end

    def syllables_per_sentence_metric
        total_syllables = 0
        sentences.each do |sentence|
            total_syllables += sentence.split(' ').map(&method(:syllables_in)).sum
        end

        total_syllables.to_f / sentences.length
    end

    def syllables_per_word_metric
        word_syllables.sum.to_f / words.length
    end

    def unique_words_metric
        unique_words.sort
    end

    def unique_words_per_paragraph_metric
        unique_words.length.to_f / paragraphs.length
    end

    def unique_words_per_paragraph_percentage_metric
        unique_words_per_paragraph_metric.to_f / words_per_paragraph_metric
    end

    def unique_words_per_sentence_metric
        unique_words.length.to_f / sentences.length
    end

    def unique_words_per_sentence_percentage_metric
        unique_words_per_sentence_metric / words_per_sentence_metric
    end

    def unique_words_percentage_metric
        unique_words.length.to_f / words.length
    end

    def vowels_per_word_percentage_metric
        squished_characters = words.join('')
        squished_characters.scan(/[aeiou]/).length.to_f / squished_characters.length
    end

    def whitespace_percentage_metric
        occurrences(of: ["\s", "\r", "\n"], within: data.chars).to_f / data.length
    end

    def word_count_metric
        words.length
    end

    def word_frequency_table_metric
        words.inject(Hash.new(0)) { |h,v| h[v] += 1; h }.reject { |k, v| v == 1 }.sort_by { |k, v| v }.reverse
    end

    def words_metric
        words
    end

    def words_per_paragraph_metric
        words.length.to_f / paragraphs.length
    end

    def words_per_sentence_metric
        words.length.to_f / sentences.length
    end

    # ... more stuffs ... #

    private

    # Given a method name (symbol), return whether it should be ran as a metric
    def metric? method_name
        method_name.to_s.end_with? '_metric'
    end

    def calculate_metrics
        results = {}
        (@metrics || all_metrics).map { |metric|
            results[metric.to_s.chomp '_metric'] = send(metric)
        }
        results
    end

    def sentences
        data.split(/[!\?\.]/)
    end

    def words
        data.downcase.gsub(/[^\s\w]/, '').split(' ')
    end

    # As defined by Robert Gunning in the GFI and SMOG
    def complex_words
        unique_words.select { |word| syllables_in(word) >= 3 }
    end

    def unique_words
        words.map(&:downcase).uniq
    end

    def word_syllables
        words.map(&method(:syllables_in))
    end

    def words_with_syllables syllable_count
        words.select { |word| syllables_in(word) == syllable_count }
    end

    def syllables_in word
        word.downcase.gsub!(/[^a-z]/, '')

        return 1 if word.length <= 3
        return SYLLABLE_COUNT_OVERRIDES[word] if SYLLABLE_COUNT_OVERRIDES.key? word

        word.sub(/(?:[^laeiouy]es|ed|[^laeiouy]e)$/, '').sub!(/^y/, '')
        word.scan(/[aeiouy]{1,2}/).length
    end

    def paragraphs
        data.split(/[\r\n\t]+/)
    end

    def occurrences of: needles, within: haystack
        of = [of] unless of.is_a? Array

        within.flatten.select { |hay| of.include? hay }.length
    end

end
