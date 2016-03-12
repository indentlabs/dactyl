class Dactylogram < ActiveRecord::Base
    include Comparable

    belongs_to :corpus

    validates :metrics, presence: true

    serialize :metrics, JSON

    before_save do
        self.reference ||= SecureRandom.uuid
    end

    def metric_report
        {
            original_string: corpus.text,
            metrics: compute_metrics!
        }
    end

    def all_metrics
        [
            [LanguageService, :language],

            [IntentService, :relation_extraction],

            [ReadabilityService, :estimated_reading_time],
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
            [WordFrequencyService, :one_syllable_words],

            [FrequencyTableService, :word_frequency_table],

            [SentimentService, :positive_words],
            [SentimentService, :negative_words],
            [SentimentService, :sentiment],
            [SentimentService, :sentiment_score],
            [SentimentService, :sentiment_score_per_sentence],
            [SentimentService, :sentiment_score_per_paragraph],

            [JargonService, :keywords],
            [JargonService, :entities],

            [ContextService, :category],
            [ContextService, :concept_tags],
            [ContextService, :taxonomy]
        ]
    end

    def compute_metrics!
        self.metrics ||= begin
            results = {}

            (@metrics || all_metrics).map do |metric|
                puts "Calculating #{metric}..."
                start = Time.now

                service, method = metric
                results["#{service}::#{method}"] = service.send(method, corpus)

                finish = Time.now
                puts "Done. Took #{(finish - start).round(5)} seconds."
            end
            results
        end

        metrics
    end


end
