class WebController < ApplicationController

    METRIC_CATEGORIES = {
        # author_similarity_index: [
        #     'most_similar_to'
        # ],

        readability: [
            'automated_readability_index',
            'coleman_liau_index',
            'flesch_kincaid_age_minimum',
            'flesch_kincaid_grade_level',
            'flesch_kincaid_reading_ease',
            'forcast_grade_level',
            'gunning_fog_index',
            'smog_grade',
            'combined_average_grade_level'
        ],

        parts_of_speech: [
            'nouns',
            'adjectives',
            'verbs',
            'adverbs',
            'conjunctions',
            'prepositions',
            'determiners',
            'acronyms',
            'unrecognized_words'
        ],

        tone: [
            'active_voice_percentage',
            'passive_voice_percentage'
        ],

        analytics: [
            'character_count',
            'characters_per_word',
            'characters_per_sentence',
            'characters_per_paragraph',
            'letters_per_word',
            'digits_per_word',
            'consonants_per_word_percentage',
            'vowels_per_word_percentage',
            'syllable_count', #rename to syllables
            'syllables_per_word',
            'syllables_per_sentence',
            'word_count', #rename to words
            'words_per_sentence',
            'words_per_paragraph',
            'unique_words_percentage',
            'unique_words_per_sentence',
            'unique_words_per_sentence_percentage',
            'unique_words_per_paragraph',
            'unique_words_per_paragraph_percentage',
            'noun_percentage',
            'adjective_percentage',
            'verb_percentage',
            'auxiliary_verbs_percentage',
            'acronyms_percentage',
            'paragraphs', # get paragraph_count
            'sentence_count', #rename to sentences
            'sentences_per_paragraph',
            'spaces_after_sentence',
            'whitespace_percentage',
            'lexical_density',
        ],

        abstractions: [
            'similes',
            'metaphors'
        ],

        frequencies: [
            'conjunction_frequency_percentage',
            'determiner_frequency_percentage',
            'preposition_frequency_percentage',
            'pronoun_frequency_percentage',
            'punctuation_percentage',
            'repeated_words_percentage',
            'special_character_percentage',
        ],

        word_frequency_tables: [
            'word_frequency_table',
            'unique_words',
            'repeated_words',
            'most_frequent_word',
            'stem_words',
            'stemmed_words',
            'filter_words',
            'stop_words',
            'auxiliary_verbs',
            'function_words',
            'insert_words',
            'lexical_words',
        ],

        context: [
            'language',
            'jargon_words',
            'related_topics'
        ],

        sentiment: [
            'sentiment',
            'glittering_generalities'
        ]
    }

    def index
        return unless @analysis_string.present?

        d = Dactylogram.new(data: @analysis_string)
        d.instance_variable_set(:@metrics, params[:metrics].map { |m| "#{m}_metric" }) if params[:metrics].present?

        @report = d.metric_report

        # Substitute in any 2nd-order metrics (that require 1st order metrics to be computed)
        #@report[:metrics]['most_similar_to'] = d.most_similar_to

        # Format metric report into format view is expecting
        @report[:metrics] = prepare_metrics_for_output @report[:metrics]
    end

    def upload
        return unless @analysis_string.present?

        d = Dactylogram.new(data: @analysis_string, identifier: params[:author])
        d.instance_variable_set(:@metrics, params[:metrics].map { |m| "#{m}_metric" }) if params[:metrics].present?
        d.send :calculate_metrics

        render json: d.save
    end

    def prepare_metrics_for_output metrics
        metrics = sanitize_values metrics
        metrics = metrics_by_category metrics
        metrics = exclude_not_implemented metrics
    end

    private

    # Categorize all the metrics into groups to avoid printing out one big list to the user
    def metrics_by_category metrics
        categorized_metrics = {}
        METRIC_CATEGORIES.keys.each do |category|
            categorized_metrics[category] = @report[:metrics].slice *METRIC_CATEGORIES[category]
        end
        categorized_metrics
    end

    # Exclude metrics with a value of "not implemented"
    def exclude_not_implemented metrics
        metrics.select do |category, metric_values|
            metric_values.select! do |m, value|
                value != "not implemented"
            end

            metric_values.any?
        end
    end

    # Sanitize metric values for text/html output
    def sanitize_values metrics
        #metrics['most_similar_to'] = metrics['most_similar_to'].reverse.chomp("authors/".reverse).reverse # god dammit ruby give me lchomp
    end

end
