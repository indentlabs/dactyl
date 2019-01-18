class WordFrequencyMetricsJob < MetricsJob
  queue_as :metrics

  def perform(book_id, *args)
    book, corpus = load_book_and_corpus_from_book_id(book_id)
    metric_group = book.metric_groupings.find_or_create_by(name: 'Sentiment')

    compute(corpus, metric_group, [
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
    ])
  end
end
