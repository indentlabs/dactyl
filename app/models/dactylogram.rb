class Dactylogram < ActiveRecord::Base
    include Treat::Core::DSL
    include Comparable

    attr_accessor :data

    validates :data, presence: true
    validates :metrics, presence: true

    serialize :metrics, JSON

    before_save do
        self.reference ||= SecureRandom.uuid
    end

    SYLLABLE_COUNT_OVERRIDES = {
        'ion' => 2
    }

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
        self.class.instance_methods.select { |m| metric? m }
    end

    def acronyms_metric
        @acroynyms_metric ||= data.gsub(/[^\s\w]/, '').split(' ').select { |word| word == word.upcase && word.length > 1 }.uniq.sort
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
        [
            automated_readability_index_metric,
            coleman_liau_index_metric,
            flesch_kincaid_grade_level_metric,
            forcast_grade_level_metric,
            gunning_fog_index_metric,
            smog_grade_metric
        ].sort.slice(1..-2).sum.to_f / 4
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

    def flesch_kincaid_age_minimum_metric
        @flesch_kincaid_age_minimum ||= case flesch_kincaid_reading_ease_metric
            when (90..100) then 11
            when (71..89)  then 12
            when (67..69)  then 13
            when (64..66)  then 14
            when (60..63)  then 15
            when (50..59)  then 18
            when (40..49)  then 21
            when (31..39)  then 24
            when (0..30)   then 25
            else ''
        end
    end

    def flesch_kincaid_grade_level_metric
        @flesch_kincaid_grade_level ||= [
            0.38 * (words.length.to_f / sentences.length),
            11.18 * (word_syllables.sum.to_f / words.length),
            -15.59
        ].sum
    end

    def flesch_kincaid_reading_ease_metric
        @flesch_kincaid_reading_ease_metric ||= [
            206.835,
            -(1.015 * words.length.to_f / sentences.length),
            -(84.6 * word_syllables.sum.to_f / words.length)
        ].sum
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

        words.select { |word| @sentiment_analyzer.get_sentiment(word) == :negative }
    end

    def nouns_metric
        nouns.sort
    end

    def noun_percentage_metric
        nouns.length.to_f / words.length
    end

    def paragraphs_metric
        paragraphs.length
    end

    def passive_voice_percentage_metric
        "not implemented"
    end

    def positive_words_metric
        load_sentiment_defaults
        @sentiment_analyzer ||= Sentimental.new

        words.select { |word| @sentiment_analyzer.get_sentiment(word) == :positive }
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

    def sentiment_score_per_sentence_metric
        return unless sentences.length > 1
        load_sentiment_defaults
        @sentiment_analyzer ||= Sentimental.new
        sentences.map { |sentence| @sentiment_analyzer.get_score sentence }
    end

    def simple_words_metric
        simple_words
    end

    def smog_grade_metric
        1.043 * Math.sqrt(complex_words.length.to_f * (30.0 / sentences.length)) + 3.1291
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
        words.length.to_f / paragraphs.length
    end

    def words_per_sentence_metric
        words.length.to_f / sentences.length
    end

    # ... more stuffs ... #

    private

    def adjectives
        @adjectives ||= words.select { |word| word.category == 'adjective' }.uniq
    end

    def adverbs
        @adverbs ||= words.select { |word| word.category == 'adverb' }.uniq
    end

    # Given a method name (symbol), return whether it should be ran as a metric
    def metric? method_name
        method_name.to_s.end_with? '_metric'
    end

    def calculate_metrics
        begin_all = Time.now
        self.metrics ||= begin
            results = {}
            (@metrics || all_metrics).map { |metric|
                print "Calculating #{metric}... "
                start = Time.now
                results[metric.to_s.chomp '_metric'] = send(metric)
                finish = Time.now
                puts "Done. Took #{(finish - start).round(5)} seconds."
            }
            results
        end
        finish_all = Time.now
        puts "Finished calculating all metrics in #{(finish_all - begin_all).round(5)} seconds."

        metrics
    end

    def conjunctions
        @conjunctions ||= words.select { |word| word.category == 'conjunction' }.uniq
    end

    def determiners
        @determiners ||= words.select { |word| word.category == 'determiner' }.uniq
    end

    def load_sentiment_defaults
        @sentiment_defaults ||= begin
            Sentimental.load_defaults
            Sentimental.threshold = 0.1
        end
    end

    def prepositions
        @prepositions ||= words.select { |word| word.category == 'preposition' }.uniq
    end

    def pronouns
        @pronouns ||= words.select { |word| I18n.t('pronouns').include? word }.uniq
    end

    def sentences
        @sentences ||= data.split(/[!\?\.]/)
    end

    def stop_words
        words.select { |word| I18n.t('stop-words').include? word }
    end

    def words
        @words ||= data.downcase.gsub(/[^\s\w]/, '').split(' ')
    end

    def nouns
        @nouns ||= words.select { |word| word.category == 'noun' }.uniq
    end

    # As defined by Robert Gunning in the GFI and SMOG
    def complex_words
        @complex_words ||= unique_words.select { |word| syllables_in(word) >= 3 }
    end

    def simple_words
        @simple_words ||= words - complex_words
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
        @paragraphs ||= data.split(/[\r\n\t]+/)
    end

    def occurrences of: needles, within: haystack
        of = [of] unless of.is_a? Array

        within.flatten.select { |hay| of.include? hay }.length
    end

    def verbs
        @verbs ||= words.select { |word| word.category == 'verb' }.uniq
    end

    def unrecognized_words
        @unrecognized_words ||= words.select { |word| word.category == 'unknown' }.uniq - pronouns
    end

end
