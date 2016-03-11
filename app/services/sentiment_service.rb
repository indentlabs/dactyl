class SentimentService
    extend Service

    #before_filter :load_sentiment_defaults

    def self.positive_words corpus
        load_sentiment_defaults
        corpus.unique_words.select { |word| @sentiment_analyzer.get_score(word) > 0.5 }.sort
    end

    def self.negative_words corpus
        load_sentiment_defaults
        corpus.unique_words.select { |word| @sentiment_analyzer.get_score(word) < -0.5 }.sort
    end

    def self.sentiment corpus
        load_sentiment_defaults
        @sentiment_analyzer.get_sentiment corpus.text
    end

    def self.sentiment_score corpus
        load_sentiment_defaults
        @sentiment_analyzer.get_score corpus.text
    end

    def self.sentiment_score_per_paragraph corpus
        return unless corpus.paragraphs.length > 1
        load_sentiment_defaults
        corpus.paragraphs.map { |paragraph| @sentiment_analyzer.get_score(paragraph).round(3) }
    end

    def self.sentiment_score_per_sentence corpus
        return unless corpus.sentences.length > 1
        load_sentiment_defaults
        corpus.sentences.map { |sentence| @sentiment_analyzer.get_score(sentence).round(3) }
    end

    private

    def self.load_sentiment_defaults
        @sentiment_defaults ||= begin
            Sentimental.load_defaults
            Sentimental.threshold = 0.1
        end

        @sentiment_analyzer ||= Sentimental.new
    end

end