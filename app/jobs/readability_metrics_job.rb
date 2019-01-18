class ReadabilityMetricsJob < MetricsJob
  queue_as :metrics

  def perform(book_id, *args)
    book, corpus = load_book_and_corpus_from_book_id(book_id)
    metric_group = book.metric_groupings.find_or_create_by(name: 'Readability')

    compute(corpus, metric_group, [
      [ReadabilityService, :estimated_reading_time],
      [ReadabilityService, :flesch_kincaid_grade_level],
      [ReadabilityService, :flesch_kincaid_age_minimum],
      [ReadabilityService, :flesch_kincaid_reading_ease],
      [ReadabilityService, :forcast_grade_level],
      [ReadabilityService, :coleman_liau_index],
      [ReadabilityService, :automated_readability_index],
      [ReadabilityService, :gunning_fog_index],
      [ReadabilityService, :combined_average_grade_level],
    ])
  end
end
