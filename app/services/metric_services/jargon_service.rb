class JargonService
    extend Service

    def self.jargon_words corpus
        #todo
    end

    def self.core_topic corpus
        #todo
    end

    def self.related_topics corpus
        #todo
    end

    def self.keywords corpus
        AlchemyAPI.search(:keyword_extraction, text: corpus.text)
            .map { |hash| hash['text'] }
            .uniq
    end

    def self.entities corpus
        AlchemyAPI.search(:entity_extraction, text: corpus.text)
    end


end