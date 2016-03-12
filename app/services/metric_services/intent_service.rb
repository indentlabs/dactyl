class IntentService
    extend Service

    def self.relation_extraction corpus
        AlchemyAPI.search(:relation_extraction, text: corpus.text)
    end

end