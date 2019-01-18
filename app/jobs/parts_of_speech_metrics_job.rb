class PartsOfSpeechMetricsJob < MetricsJob
  queue_as :metrics

  def perform(book_id, *args)
    book, corpus = load_book_and_corpus_from_book_id(book_id)
    metric_group = book.metric_groupings.find_or_create_by(name: 'Parts of Speech')

    compute(corpus, metric_group, [
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
    ])
  end
end
