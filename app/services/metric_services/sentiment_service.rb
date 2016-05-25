class SentimentService
  extend Service

  def self.positive_words corpus
    load_sentiment_defaults
    corpus.unique_words.select { |word| @sentiment_analyzer.score(word) > 0.5 }.sort
  end

  def self.negative_words corpus
    load_sentiment_defaults
    corpus.unique_words.select { |word| @sentiment_analyzer.score(word) < -0.5 }.sort
  end

  def self.sentiment corpus
    load_sentiment_defaults
    @sentiment_analyzer.sentiment corpus.text
  end

  def self.sentiment_score corpus
    load_sentiment_defaults
    @sentiment_analyzer.score corpus.text
  end

  def self.sentiment_score_per_paragraph corpus
    return unless corpus.paragraphs.length > 1
    load_sentiment_defaults
    corpus.paragraphs.map { |paragraph| @sentiment_analyzer.score(paragraph).round(3) }
  end

  def self.sentiment_score_per_sentence corpus
    return unless corpus.sentences.length > 1
    load_sentiment_defaults
    corpus.sentences.map { |sentence| @sentiment_analyzer.score(sentence).round(3) }
  end

  private

  def self.load_sentiment_defaults
    @sentiment_analyzer ||= Sentimental.new.tap do |s|
      s.load_defaults
      s.threshold = 0.1
    end
  end

end