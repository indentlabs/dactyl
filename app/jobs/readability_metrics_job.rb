class ReadabilityMetricsJob < MetricsJob
  queue_as :metrics

  def perform(book_id, *args)
    book, corpus = load_book_and_corpus_from_book_id(book_id)
    metric_group = book.metric_groupings.find_or_create_by(name: 'Readability')

    compute(corpus, metric_group, [
      [ReadabilityService, :estimated_reading_time, :time_estimate],
      [ReadabilityService, :flesch_kincaid_grade_level, :grade_level_scale],
      [ReadabilityService, :flesch_kincaid_age_minimum, :age_estimate],
      [ReadabilityService, :flesch_kincaid_reading_ease, :readability_scale],
      [ReadabilityService, :forcast_grade_level, :grade_level_scale],
      [ReadabilityService, :coleman_liau_index, :grade_level_scale],
      [ReadabilityService, :automated_readability_index, :readability_scale],
      [ReadabilityService, :gunning_fog_index, :grade_level_scale],
      [ReadabilityService, :smog_grade, :grade_level_scale],
      [ReadabilityService, :combined_average_grade_level, :grade_level_scale],
    ])
  end
end
