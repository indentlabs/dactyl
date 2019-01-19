class Book < ApplicationRecord
  has_many :book_has_genres
  has_many :genres, through: :book_has_genres

  has_many :publish_dates
  has_many :publishers,    through: :publish_dates
  has_many :authors,       through: :publish_dates
  has_many :hosted_corpus, through: :publish_dates

  has_many :chapters

  has_many :character_appearances
  has_many :characters, through: :character_appearances

  has_many :metric_groupings, as: :prose
  has_many :metrics, through: :metric_groupings

  extend FriendlyId
  friendly_id :title, use: :slugged

  def reindex
    [
      ContextMetricsJob,
      FrequencyMetricsJob,
      IntentMetricsJob,
      JargonMetricsJob,
      LanguageMetricsJob,
      PartsOfSpeechMetricsJob,
      ReadabilityMetricsJob,
      SentimentMetricsJob,
      WordFrequencyMetricsJob
    ].each { |worker| worker.perform_later(self.id) }
  end
end
