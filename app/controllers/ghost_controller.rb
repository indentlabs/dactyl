class GhostController < ApplicationController
  before_action :authenticate_user!

  ALWAYS_SHOWING_METRICS = [
    'WordFrequencyService::word_count',
    'ReadabilityService::estimated_reading_time'
  ]

  METRICS_IN_EDITOR = [
    'ReadabilityService::flesch_kincaid_grade_level',
    # 'ReadabilityService::flesch_kincaid_age_minimum',
    'ReadabilityService::flesch_kincaid_reading_ease',
    # 'ReadabilityService::forcast_grade_level',
    # 'ReadabilityService::coleman_liau_index',
    # 'ReadabilityService::automated_readability_index',
    # 'ReadabilityService::gunning_fog_index',
    # 'ReadabilityService::combined_average_grade_level',
    # 'WordFrequencyService::acronyms_percentage',
    'WordFrequencyService::adjective_percentage',
    # 'WordFrequencyService::auxiliary_verbs_percentage',
    # 'WordFrequencyService::characters_per_paragraph',
    # 'WordFrequencyService::characters_per_sentence',
    # 'WordFrequencyService::characters_per_word',
    'WordFrequencyService::conjunction_percentage',
    # 'WordFrequencyService::consonants_per_word_percentage',
    # 'WordFrequencyService::digits_per_word',
    'WordFrequencyService::determiner_percentage',
    'WordFrequencyService::noun_percentage',
    # 'WordFrequencyService::numbers_percentage',
    'WordFrequencyService::preposition_percentage',
    'WordFrequencyService::pronoun_percentage',
    # 'WordFrequencyService::punctuation_percentage',
    # 'WordFrequencyService::repeated_word_percentage',
    # 'WordFrequencyService::spaces_after_sentence',
    # 'WordFrequencyService::special_character_percentage',
    # 'WordFrequencyService::syllables_per_sentence',
    # 'WordFrequencyService::syllables_per_word',
    # 'WordFrequencyService::unique_words_per_paragraph',
    # 'WordFrequencyService::unique_words_per_paragraph_percentage',
    # 'WordFrequencyService::unique_words_per_sentence',
    # 'WordFrequencyService::unique_words_per_sentence_percentage',
    # 'WordFrequencyService::unique_words_percentage',
    'WordFrequencyService::verb_percentage',
    # 'WordFrequencyService::vowels_per_word_percentage',
    # 'WordFrequencyService::whitespace_percentage',
    'WordFrequencyService::words_per_paragraph',
    'WordFrequencyService::words_per_sentence',
    # 'WordFrequencyService::one_syllable_words'
  ]

  def index
  end

  def editor
    # TODO: this should be Identity has_many :dactylograms
    # TODO: let user specify which dactylogram to guide
    @dactyl = Dactylogram.find(params[:dactylogram_id])

    # TODO: uhhh this name
    @alwaysshowingmetrics = ALWAYS_SHOWING_METRICS
    @metrics = @dactyl.metrics.select { |k, v| METRICS_IN_EDITOR.include? k }
  end

  def browser
  end
end
