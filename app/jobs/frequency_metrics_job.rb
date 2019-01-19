class FrequencyMetricsJob < MetricsJob
  queue_as :metrics

  def perform(book_id, *args)
    book, corpus = load_book_and_corpus_from_book_id(book_id)
    metric_group = book.metric_groupings.find_or_create_by(name: 'Frequency')

    compute(corpus, metric_group, [
      [FrequencyTableService, :word_frequency_table, :frequency_table],
    ])
  end
end
