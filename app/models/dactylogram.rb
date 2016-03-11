class Dactylogram < ActiveRecord::Base
    include Treat::Core::DSL
    include Comparable

    require 'action_view'
    include ActionView::Helpers::DateHelper

    attr_accessor :data

    validates :data, presence: true
    validates :metrics, presence: true

    belongs_to :corpus

    serialize :metrics, JSON

    before_save do
        self.reference ||= SecureRandom.uuid
    end

    #n-dimensional cartesian distance on shared metrics
    def distance_to other_dactylogram
        puts "Computing distance to #{other_dactylogram.identifier}"

        shared_metrics = self.metrics.keys & other_dactylogram.metrics.keys
        distance = shared_metrics.map do |metric|
            if metric.class == Fixnum || metric.class == Float
                (metrics[metric] - other_dactylogram.metrics[metric]).abs
            else
                0
            end
        end.sum
    end

    def metric_report
        {
            original_string: data,
            metrics: calculate_metrics
        }
    end

    def all_metrics
        [
            :acronyms_metric,
            :acronyms_percentage_metric,
            :active_voice_percentage_metric,
            :adjectives_metric,
            :adjective_percentage_metric,
            :adverbs_metric,
            :automated_readability_index_metric,
            :auxiliary_verbs_metric,
            :auxiliary_verbs_percentage_metric,
            :character_count_metric,
            :characters_per_paragraph_metric,
            :characters_per_sentence_metric,
            :characters_per_word_metric,
            :coleman_liau_index_metric,
            :combined_average_grade_level_metric,
            :complex_words_metric,
            :conjunctions_metric,
            :conjunction_percentage_metric,
            :consonants_per_word_percentage_metric,
            :digits_per_word_metric,
            :determiners_metric,
            :determiner_percentage_metric,
            :flesch_kincaid_age_minimum_metric,
            :flesch_kincaid_reading_ease_metric,
            :forcast_grade_level_metric,
            :glittering_generalities_metric,
            :filter_words_metric,
            :function_words_metric,
            :gunning_fog_index_metric,
            :insert_words_metric,
            :jargon_words_metric,
            :language_metric,
            :lexical_words_metric,
            :lexical_density_metric,
            :metaphors_metric,
            :most_frequent_word_metric,
            :negative_words_metric,
            :nouns_metric,
            :noun_percentage_metric,
            :numbers_metric,
            :numbers_percentage_metric,
            :paragraphs_metric,
            :passive_voice_percentage_metric,
            :positive_words_metric,
            :prepositions_metric,
            :preposition_percentage_metric,
            :pronouns_metric,
            :pronoun_percentage_metric,
            :punctuation_percentage_metric,
            :estimated_reading_time_metric,
            :related_topics_metric,
            :repeated_words_metric,
            :repeated_word_percentage_metric,
            :similes_metric,
            :sentence_count_metric,
            :sentences_metric,
            :sentences_per_paragraph_metric,
            :sentiment_metric,
            :sentiment_score_metric,
            :sentiment_score_per_paragraph_metric,
            :sentiment_score_per_sentence_metric,
            :simple_words_metric,
            :smog_grade_metric,
            :spaces_after_sentence_metric,
            :special_character_percentage_metric,
            :stem_words_metric,
            :stemmed_words_metric,
            :stop_words_metric,
            :syllable_count_metric,
            :syllables_per_sentence_metric,
            :syllables_per_word_metric,
            :one_syllable_words_metric,
            :unique_words_metric,
            :unique_words_per_paragraph_metric,
            :unique_words_per_paragraph_percentage_metric,
            :unique_words_per_sentence_metric,
            :unique_words_per_sentence_percentage_metric,
            :unique_words_percentage_metric,
            :unrecognized_words_metric,
            :verbs_metric,
            :verb_percentage_metric,
            :vowels_per_word_percentage_metric,
            :whitespace_percentage_metric,
            :word_count_metric,
            :word_frequency_table_metric,
            :words_metric,
            :words_per_paragraph_metric,
            :words_per_sentence_metric
        ]
    end

    def acronyms_metric
        @acroynyms_metric ||= data.gsub(/[^\s\w]/, '')
            .split(' ')
            .select { |word| word == word.upcase && word.length > 1 && !is_numeric?(word) }
            .uniq
            .sort
    end

    def acronyms_percentage_metric
        acronyms_metric.length.to_f / words.length
    end

    def active_voice_percentage_metric
        "not implemented"
    end

    def adjectives_metric
        adjectives.sort
    end

    def adjective_percentage_metric
        adjectives.length.to_f / words.length
    end

    def adverbs_metric
        adverbs.sort
    end

    def automated_readability_index_metric
        @automated_readability_index ||= [
            4.71 * data.chars.reject(&:blank?).length.to_f / words.length,
            0.5 * words.length.to_f / sentences.length,
            -21.43
        ].sum
    end

    def auxiliary_verbs_metric
        words.select { |word| I18n.t('auxillary-verbs').include? word }.uniq.sort
    end

    def auxiliary_verbs_percentage_metric
        auxiliary_verbs_metric.length.to_f / words.length
    end

    def character_count_metric
        data.length
    end

    def characters_per_paragraph_metric
        return unless paragraphs.length > 1
        data.chars.length.to_f / paragraphs.length
    end

    def characters_per_sentence_metric
        data.length.to_f / sentences.length
    end

    def characters_per_word_metric
        words.map(&:length).sum.to_f / words.length
    end

    def coleman_liau_index_metric
        @coleman_liau_index ||= [
            0.0588 * 100 * data.chars.length.to_f / words.length,
            -0.296 * 100 / (words.length.to_f / sentences.length),
            -15.8
        ].sum
    end

    def combined_average_grade_level_metric
        scores = [
            automated_readability_index_metric,
            coleman_liau_index_metric,
            FleschKincaidService.grade_level(@corpus),
            forcast_grade_level_metric,
            gunning_fog_index_metric,
            smog_grade_metric
        ]
        scores.reject! &:nan?
        scores.reject! { |hasselhoff| hasselhoff.abs == Float::INFINITY }

        return unless scores.length > 2

        scores.sort.slice(1..-2).sum.to_f / 4
    end

    def complex_words_metric
        complex_words
    end

    def conjunctions_metric
        conjunctions.sort
    end

    def conjunction_percentage_metric
        words.select { |word| I18n.t('conjunctions').include? word }.length.to_f / words.length
    end

    def consonants_per_word_percentage_metric
        squished_characters = words.join('')
        squished_characters.scan(/[^aeiou]/).length.to_f / squished_characters.length
    end

    def digits_per_word_metric
        squished_characters = words.join('')
        squished_characters.scan(/[0-9]/).length.to_f / squished_characters.length
    end

    def determiners_metric
        determiners.sort
    end

    def determiner_percentage_metric
        words.select { |word| I18n.t('determiners').include? word }.length.to_f / words.length
    end

    def forcast_grade_level_metric
        @forcast_grade_level ||= 20 - (((words_with_syllables(1).length.to_f / words.length) * 150) / 10.0)
    end

    def glittering_generalities_metric
        # some infoz http://www.buzzle.com/articles/examples-of-glittering-generalities.html
        "not implemented"
    end

    def filter_words_metric
        "not implemented"
    end

    def function_words_metric
        "not implemented"
    end

    def gunning_fog_index_metric
        #todo GFI word/suffix exclusions
        @gunning_fog_index ||= 0.4 * (words.length.to_f / sentences.length + 100 * (complex_words.length.to_f / words.length))
    end

    def insert_words_metric
        words.select { |word| I18n.t('insert-words').include? word }.uniq.sort
    end

    def jargon_words_metric
        "not implemented"
    end

    def language_metric
        "not implemented"
    end

    def lexical_words_metric
        function_words_metric
    end

    def lexical_density_metric
        "not implemented"
    end

    def metaphors_metric
        "not implemented"
    end

    def most_frequent_word_metric
        (word_frequency_table_metric.max_by { |k, v| v } || words).first
    end

    def most_similar_to
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

    def negative_words_metric
        load_sentiment_defaults
        @sentiment_analyzer ||= Sentimental.new

        unique_words.select { |word| @sentiment_analyzer.get_score(word) < -0.5 }.sort
    end

    def nouns_metric
        nouns.sort
    end

    def noun_percentage_metric
        nouns.length.to_f / words.length
    end

    def numbers_metric
        numbers
    end

    def numbers_percentage_metric
        numbers.length.to_f / (words.length + numbers.length).to_f
    end

    def paragraphs_metric
        return unless paragraphs.length > 1
        paragraphs.length
    end

    def passive_voice_percentage_metric
        "not implemented"
    end

    def positive_words_metric
        load_sentiment_defaults
        @sentiment_analyzer ||= Sentimental.new

        unique_words.select { |word| @sentiment_analyzer.get_score(word) > 0.5 }.sort
    end

    def prepositions_metric
        prepositions.sort
    end

    def preposition_percentage_metric
        words.select { |word| I18n.t('prepositions').include? word }.length.to_f / words.length
    end

    def pronouns_metric
        pronouns.sort
    end

    def pronoun_percentage_metric
        pronouns.length.to_f / words.length
    end

    def punctuation_percentage_metric
        data.scan(/[\.,;\?!\-"':\(\)\[\]"]/).length.to_f / data.chars.length
    end

    def estimated_reading_time_metric
        average_wpm = 200

        words_per_second = average_wpm / 60
        seconds_to_read = words.length / words_per_second

        distance_of_time_in_words(seconds_to_read)
    end

    def related_topics_metric
        "not implemented"
    end

    def repeated_words_metric
        @repeated_words_metric ||= words.select {|e| words.rindex(e) != words.index(e) }.uniq.sort
    end

    def repeated_word_percentage_metric
        repeated_words_metric.length.to_f / words.length
    end

    def similes_metric
        "not implemented"
    end

    def sentence_count_metric
        sentences.length
    end

    def sentences_metric
        sentences
    end

    def sentences_per_paragraph_metric
        return unless paragraphs.length > 1
        sentences.length.to_f / paragraphs.length
    end

    def sentiment_metric
        load_sentiment_defaults
        @sentiment_analyzer ||= Sentimental.new
        @sentiment_analyzer.get_sentiment data
    end

    def sentiment_score_metric
        load_sentiment_defaults
        @sentiment_analyzer ||= Sentimental.new
        @sentiment_analyzer.get_score data
    end

    def sentiment_score_per_paragraph_metric
        return unless paragraphs.length > 1
        load_sentiment_defaults
        @sentiment_analyzer ||= Sentimental.new
        paragraphs.map { |paragraph| @sentiment_analyzer.get_score(paragraph).round(3) }
    end

    def sentiment_score_per_sentence_metric
        return unless sentences.length > 1
        load_sentiment_defaults
        @sentiment_analyzer ||= Sentimental.new
        sentences.map { |sentence| @sentiment_analyzer.get_score(sentence).round(3) }
    end

    def simple_words_metric
        simple_words
    end

    def smog_grade_metric
        @smog_grade ||= 1.043 * Math.sqrt(complex_words.length.to_f * (30.0 / sentences.length)) + 3.1291
    end

    def spaces_after_sentence_metric
        spaces_per_sentence = sentences.map { |sentence|
            sentence.length - sentence.gsub(/^ +/, '').length
        }.reject(&:zero?)

        spaces = spaces_per_sentence.sum.to_f / spaces_per_sentence.length
        spaces = 0 if spaces.nan?
        spaces
    end

    def special_character_percentage_metric
        data.scan(/[\$\^#@%~]/).length.to_f / data.chars.length
    end

    def stem_words_metric
        words.select { |word| word.try(:stem) == word }.uniq.sort
    end

    def stemmed_words_metric
        words.select { |word| word.try(:stem) != word }.uniq.sort
    end

    def stop_words_metric
        stop_words.uniq.sort
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

    def one_syllable_words_metric
        # todo, etc
    end

    def unique_words_metric
        unique_words.sort
    end

    def unique_words_per_paragraph_metric
        return unless paragraphs.length > 1
        unique_words.length.to_f / paragraphs.length
    end

    def unique_words_per_paragraph_percentage_metric
        return unless paragraphs.length > 1
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

    def unrecognized_words_metric
        unrecognized_words.sort
    end

    def verbs_metric
        verbs.sort
    end

    def verb_percentage_metric
        verbs.length.to_f / words.length
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
        table = words.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
        table.reject! { |k, v| v == 1 } if table.any? { |k, v| v > 1 } && table.length > 50
        table = Hash[table.sort_by { |k, v| v }.reverse]
        table
    end

    def words_metric
        words
    end

    def words_per_paragraph_metric
        return unless paragraphs.length > 1
        words.length.to_f / paragraphs.length
    end

    def words_per_sentence_metric
        words.length.to_f / sentences.length
    end

    # ... more stuffs ... #

    private

    def calculate_metrics
        @corpus = Corpus.new data

        self.metrics ||= begin
            results = {}

            (@metrics || all_metrics).map do |metric|
                puts "Calculating #{metric}..."
                start = Time.now

                service, method = metric
                results["#{service}::#{method}"] = service.send(method, @corpus)

                finish = Time.now
                puts "Done. Took #{(finish - start).round(5)} seconds."
            end
            results
        end

        metrics
    end

    def load_sentiment_defaults
        @sentiment_defaults ||= begin
            Sentimental.load_defaults
            Sentimental.threshold = 0.1
        end
    end


end
