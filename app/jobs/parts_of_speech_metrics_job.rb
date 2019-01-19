class PartsOfSpeechMetricsJob < MetricsJob
  queue_as :metrics

  def perform(book_id, *args)
    book, corpus = load_book_and_corpus_from_book_id(book_id)
    metric_group = book.metric_groupings.find_or_create_by(name: 'Parts of Speech')

    compute(corpus, metric_group, [
      [PartsOfSpeechService, :acronyms, :word_list],
      [PartsOfSpeechService, :adjectives, :word_list],
      [PartsOfSpeechService, :adverbs, :word_list],
      [PartsOfSpeechService, :auxiliary_verbs, :word_list],
      [PartsOfSpeechService, :complex_words, :word_list],
      [PartsOfSpeechService, :conjunctions, :word_list],
      [PartsOfSpeechService, :determiners, :word_list],
      [PartsOfSpeechService, :insert_words, :word_list],
      [PartsOfSpeechService, :nouns, :word_list],
      [PartsOfSpeechService, :numbers, :word_list],
      [PartsOfSpeechService, :prepositions, :word_list],
      [PartsOfSpeechService, :pronouns, :word_list],
      [PartsOfSpeechService, :repeated_words, :word_list],
      [PartsOfSpeechService, :simple_words, :word_list],
      [PartsOfSpeechService, :stem_words, :word_list],
      [PartsOfSpeechService, :stemmed_words, :word_list],
      [PartsOfSpeechService, :stop_words, :word_list],
      [PartsOfSpeechService, :unique_words, :word_list],
      [PartsOfSpeechService, :unrecognized_words, :word_list],
      [PartsOfSpeechService, :verbs, :word_list],
    ])
  end
end
