class WordFrequencyMetricsJob < MetricsJob
  queue_as :metrics

  def perform(book_id, *args)
    book, corpus = load_book_and_corpus_from_book_id(book_id)
    metric_group = book.metric_groupings.find_or_create_by(name: 'Word Frequency')

    compute(corpus, metric_group, [
      [WordFrequencyService, :acronyms_percentage, :percentage],
      [WordFrequencyService, :adjective_percentage, :percentage],
      [WordFrequencyService, :auxiliary_verbs_percentage, :percentage],
      [WordFrequencyService, :character_count, :integer],
      [WordFrequencyService, :characters_per_paragraph],
      [WordFrequencyService, :characters_per_sentence],
      [WordFrequencyService, :characters_per_word],
      [WordFrequencyService, :conjunction_percentage, :percentage],
      [WordFrequencyService, :consonants_per_word_percentage, :percentage],
      [WordFrequencyService, :digits_per_word],
      [WordFrequencyService, :determiner_percentage, :percentage],
      [WordFrequencyService, :most_frequent_word, :word_singular],
      [WordFrequencyService, :noun_percentage, :percentage],
      [WordFrequencyService, :numbers_percentage, :percentage],
      [WordFrequencyService, :preposition_percentage, :percentage],
      [WordFrequencyService, :pronoun_percentage, :percentage],
      [WordFrequencyService, :punctuation_percentage, :percentage],
      [WordFrequencyService, :repeated_word_percentage, :percentage],
      [WordFrequencyService, :sentence_count, :integer],
      [WordFrequencyService, :sentences_per_paragraph],
      [WordFrequencyService, :spaces_after_sentence],
      [WordFrequencyService, :special_character_percentage, :percentage],
      [WordFrequencyService, :syllable_count, :integer],
      [WordFrequencyService, :syllables_per_sentence],
      [WordFrequencyService, :syllables_per_word],
      [WordFrequencyService, :unique_words_per_paragraph],
      [WordFrequencyService, :unique_words_per_paragraph_percentage, :percentage],
      [WordFrequencyService, :unique_words_per_sentence],
      [WordFrequencyService, :unique_words_per_sentence_percentage, :percentage],
      [WordFrequencyService, :unique_words_percentage, :percentage],
      [WordFrequencyService, :verb_percentage, :percentage],
      [WordFrequencyService, :vowels_per_word_percentage, :percentage],
      [WordFrequencyService, :whitespace_percentage, :percentage],
      [WordFrequencyService, :word_count, :integer],
      [WordFrequencyService, :words_per_paragraph],
      [WordFrequencyService, :words_per_sentence],
      [WordFrequencyService, :one_syllable_words],
    ])
  end
end
