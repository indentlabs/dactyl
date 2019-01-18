class SentimentMetricsJob < MetricsJob
  queue_as :metrics

  def perform(book_id, *args)
    book, corpus = load_book_and_corpus_from_book_id(book_id)
    metric_group = book.metric_groupings.find_or_create_by(name: 'Sentiment')

    compute(corpus, metric_group, [
      [SentimentService, :positive_words],
      [SentimentService, :negative_words],
      [SentimentService, :sentiment],
      [SentimentService, :sentiment_score],
      [SentimentService, :sentiment_score_per_sentence],
      [SentimentService, :sentiment_score_per_paragraph],
    ])
  end
end
