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
            metrics: calculate_metrics!
        }
    end

    def all_metrics
        [
            [ReadabilityService, :flesch_kincaid_grade_level],
            [ReadabilityService, :flesch_kincaid_age_minimum],
            [ReadabilityService, :flesch_kincaid_reading_ease],
            [ReadabilityService, :forcast_grade_level],
            [ReadabilityService, :coleman_liau_index],
            [ReadabilityService, :automated_readability_index],
            [ReadabilityService, :gunning_fog_index],
            [ReadabilityService, :combined_average_grade_level],

            [PartsOfSpeechService, :acronyms],
            [PartsOfSpeechService, :adjectives],
            [PartsOfSpeechService, :adverbs],
            [PartsOfSpeechService, :auxiliary_verbs],
            [PartsOfSpeechService, :complex_words],
            [PartsOfSpeechService, :conjunctions],
            [PartsOfSpeechService, :determiners],
            [PartsOfSpeechService, :insert_words],
            [PartsOfSpeechService, :nouns],
            [PartsOfSpeechService, :numbers],
            [PartsOfSpeechService, :prepositions],
            [PartsOfSpeechService, :pronouns],
            [PartsOfSpeechService, :repeated_words],
            [PartsOfSpeechService, :simple_words],
            [PartsOfSpeechService, :stem_words],
            [PartsOfSpeechService, :stemmed_words],
            [PartsOfSpeechService, :stop_words],
            [PartsOfSpeechService, :unique_words],
            [PartsOfSpeechService, :unrecognized_words],
            [PartsOfSpeechService, :verbs],
            [PartsOfSpeechService, :adjectives],

            [WordFrequencyService, :acronyms_percentage],
            [WordFrequencyService, :adjective_percentage],
            [WordFrequencyService, :auxiliary_verbs_percentage],
            [WordFrequencyService, :character_count],
            [WordFrequencyService, :characters_per_paragraph],
            [WordFrequencyService, :characters_per_sentence],
            [WordFrequencyService, :characters_per_word],
            [WordFrequencyService, :conjunction_percentage],
            [WordFrequencyService, :consonants_per_word_percentage],
            [WordFrequencyService, :digits_per_word],
            [WordFrequencyService, :determiner_percentage],
            [WordFrequencyService, :most_frequent_word],
            [WordFrequencyService, :noun_percentage],
            [WordFrequencyService, :numbers_percentage],
            [WordFrequencyService, :preposition_percentage],
            [WordFrequencyService, :pronoun_percentage],
            [WordFrequencyService, :punctuation_percentage],
            [WordFrequencyService, :repeated_word_percentage],
            [WordFrequencyService, :sentence_count],
            [WordFrequencyService, :sentences_per_paragraph],
            [WordFrequencyService, :spaces_after_sentence],
            [WordFrequencyService, :special_character_percentage],
            [WordFrequencyService, :syllable_count],
            [WordFrequencyService, :syllables_per_sentence],
            [WordFrequencyService, :syllables_per_word],
            [WordFrequencyService, :unique_words_per_paragraph],
            [WordFrequencyService, :unique_words_per_paragraph_percentage],
            [WordFrequencyService, :unique_words_per_sentence],
            [WordFrequencyService, :unique_words_per_sentence_percentage],
            [WordFrequencyService, :unique_words_percentage],
            [WordFrequencyService, :verb_percentage],
            [WordFrequencyService, :vowels_per_word_percentage],
            [WordFrequencyService, :whitespace_percentage],
            [WordFrequencyService, :word_count],
            [WordFrequencyService, :words_per_paragraph],
            [WordFrequencyService, :words_per_sentence],

            [FrequencyTableService, :word_frequency_table],

            [SentimentService, :positive_words],
            [SentimentService, :negative_words],
            [SentimentService, :sentiment],
            [SentimentService, :sentiment_score],
            [SentimentService, :sentiment_score_per_sentence],
            [SentimentService, :sentiment_score_per_paragraph],

        ]
    end


    def active_voice_percentage_metric
        "not implemented"
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

    def jargon_words_metric
        "not implemented"
    end

    def language_metric
        "not implemented"
    end

    def lexical_density_metric
        "not implemented"
    end

    def metaphors_metric
        "not implemented"
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

    def passive_voice_percentage_metric
        "not implemented"
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

    def similes_metric
        "not implemented"
    end

    

    def one_syllable_words_metric
        # todo, etc
    end

    

    def word_frequency_table_metric
        table = words.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
        table.reject! { |k, v| v == 1 } if table.any? { |k, v| v > 1 } && table.length > 50
        table = Hash[table.sort_by { |k, v| v }.reverse]
        table
    end

    # ... more stuffs ... #

    private

    def calculate_metrics!
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


end
