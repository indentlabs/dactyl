class Dactylogram < ActiveRecord::Base
    include Treat::Core::DSL

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

    STOP_WORDS = ["a", "about", "above", "above", "across", "after", "afterwards", 
        "again", "against", "all", "almost", "alone", "along", "already", "also",
        "although", "always","am","among", "amongst", "amoungst", "amount",  "an", 
        "and", "another", "any","anyhow","anyone","anything","anyway", "anywhere", 
        "are", "around", "as",  "at", "back","be","became", "because","become",
        "becomes", "becoming", "been", "before", "beforehand", "behind", "being", 
        "below", "beside", "besides", "between", "beyond", "bill", "both", 
        "bottom","but", "by", "call", "can", "cannot", "cant", "co", "con", "could", 
        "couldnt", "cry", "de", "describe", "detail", "do", "done", "down", "due", 
        "during", "each", "eg", "eight", "either", "eleven","else", "elsewhere", 
        "empty", "enough", "etc", "even", "ever", "every", "everyone", "everything", 
        "everywhere", "except", "few", "fifteen", "fify", "fill", "find", "fire", 
        "first", "five", "for", "former", "formerly", "forty", "found", "four", 
        "from", "front", "full", "further", "get", "give", "go", "had", "has", "hasnt", 
        "have", "he", "hence", "her", "here", "hereafter", "hereby", "herein", 
        "hereupon", "hers", "herself", "him", "himself", "his", "how", "however", 
        "hundred", "ie", "if", "in", "inc", "indeed", "interest", "into", "is", "it", 
        "its", "itself", "keep", "last", "latter", "latterly", "least", "less", "ltd", 
        "made", "many", "may", "me", "meanwhile", "might", "mill", "mine", "more", 
        "moreover", "most", "mostly", "move", "much", "must", "my", "myself", "name", 
        "namely", "neither", "never", "nevertheless", "next", "nine", "no", "nobody", 
        "none", "noone", "nor", "not", "nothing", "now", "nowhere", "of", "off", 
        "often", "on", "once", "one", "only", "onto", "or", "other", "others", 
        "otherwise", "our", "ours", "ourselves", "out", "over", "own","part", "per", 
        "perhaps", "please", "put", "rather", "re", "same", "see", "seem", "seemed", 
        "seeming", "seems", "serious", "several", "she", "should", "show", "side", 
        "since", "sincere", "six", "sixty", "so", "some", "somehow", "someone", 
        "something", "sometime", "sometimes", "somewhere", "still", "such", "system", 
        "take", "ten", "than", "that", "the", "their", "them", "themselves", "then", 
        "thence", "there", "thereafter", "thereby", "therefore", "therein", "thereupon", 
        "these", "they", "thickv", "thin", "third", "this", "those", "though", "three", 
        "through", "throughout", "thru", "thus", "to", "together", "too", "top", "toward", 
        "towards", "twelve", "twenty", "two", "un", "under", "until", "up", "upon", "us", 
        "very", "via", "was", "we", "well", "were", "what", "whatever", "when", "whence", 
        "whenever", "where", "whereafter", "whereas", "whereby", "wherein", "whereupon", 
        "wherever", "whether", "which", "while", "whither", "who", "whoever", "whole", 
        "whom", "whose", "why", "will", "with", "within", "without", "would", "yet", 
        "you", "your", "yours", "yourself", "yourselves", "the"]

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

    def acronyms_percentage_metric
        "not implemented"
    end

    def active_voice_percentage_metric
        "not implemented"
    end

    def adjectives_metric
        adjectives
    end

    def adjective_percentage_metric
        adjectives.length.to_f / words.length
    end

    def adverbs_metric
        adverbs
    end

    def automated_readability_index_metric
        [
            4.71 * data.chars.reject(&:blank?).length.to_f / words.length,
            0.5 * words.length.to_f / sentences.length,
            -21.43
        ].sum
    end

    def auxiliary_verbs_metric
        "not implemented"
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

    def conjunctions_metric
        conjunctions
    end

    def conjunction_frequency_metric
        words.select { |word| CONJUNCTIONS.include? word }.length.to_f / words.length
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

    def determiners_metric
        determiners
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

    def glittering_generalities_metric
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
        0.4 * (words.length.to_f / sentences.length + 100 * (complex_words.length.to_f / words.length))
    end

    def insert_words_metric
        "not implemented"
    end

    def jargon_words_metric
        "not implemented"
    end

    def language_metric
        "not implemented"
    end

    def letters_per_word_metric
        data.chars.length.to_f / words.length
    end

    def lexical_words_metric
        "not implemented"
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

    def nouns_metric
        nouns
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

    def prepositions_metric
        prepositions
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

    def related_topics_metric
        "not implemented"
    end

    def repeated_words_metric
        words.select {|e| words.rindex(e) != words.index(e) }.uniq
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

    def stem_words_metric
        words.select { |word| word.try(:stem) == word }
    end

    def stemmed_words_metric
        words.select { |word| word.try(:stem) != word }
    end

    def stop_words_metric
        stop_words
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

    def unrecognized_words_metric
        unrecognized_words
    end

    def verbs_metric
        verbs
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
        table.reject! { |k, v| v == 1 } if table.any? { |k, v| v > 1 }
        table.sort_by { |k, v| v }.reverse!
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
        @adjectives ||= words.select { |word| word.category == 'adjective' }
    end

    def adverbs
        @adverbs ||= words.select { |word| word.category == 'adverb' }
    end

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

    def conjunctions
        @conjunctions ||= words.select { |word| word.category == 'conjunction' }
    end

    def determiners
        @determiners ||= words.select { |word| word.category == 'determiner' }
    end

    def prepositions
        @prepositions ||= words.select { |word| word.category == 'preposition' }
    end

    def sentences
        data.split(/[!\?\.]/)
    end

    def stop_words
        words.select { |word| STOP_WORDS.include? word }
    end

    def words
        data.downcase.gsub(/[^\s\w]/, '').split(' ')
    end

    def nouns
        @nouns ||= words.select { |word| word.category == 'noun' }
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

    def verbs
        @verbs ||= words.select { |word| word.category == 'verb' }
    end

    def unrecognized_words
        @unrecognized_words ||= words.select { |word| word.category == 'unknown' }
    end

end
