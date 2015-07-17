class Dactylogram < ActiveRecord::Base
    attr_accessor :data

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

    def average_sentence_length_metric
        data.length.to_f / sentences.length
    end

    def automated_readability_index_metric
        [
            4.71 * data.chars.reject(&:blank?).length.to_f / words.length,
            0.5 * words.length.to_f / sentences.length,
            -21.43
        ].sum
    end

    def coleman_liau_index_metric
        [
            0.0588 * 100 * data.chars.length.to_f / words.length,
            -0.296 * 100 / (words.length.to_f / sentences.length),
            -15.8
        ].sum
    end

    def data_length_metric
        data.length
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

    def sentences_metric
        sentences.length
    end

    def smog_grade_metric
        1.043 * Math.sqrt(complex_words.length.to_f * (30.0 / sentences.length)) + 3.1291
    end

    def spaces_after_sentence_metric
        spaces_per_sentence = sentences.map { |sentence|
            sentence.length - sentence.lstrip.length
        }.sum.to_f / (sentences.length - 1)
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

    def unique_words_percentage_metric
        unique_words.length.to_f / words.length
    end

    def whitespace_percentage_metric
        occurrences(of: ["\s", "\r", "\n"], within: data.chars).to_f / data.length
    end

    def word_count_metric
        words.length
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
        data.gsub(/[^\s\w]/, '').split(' ')
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
        word.scan(/[aeiouy]{1,2}/).size
    end

    def occurrences of: needles, within: haystack
        of = [of] unless of.is_a? Array

        within.flatten.select { |hay| of.include? hay }.length
    end

end
