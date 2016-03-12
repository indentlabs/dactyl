class ContextService
    extend Service

    def self.concept_tags corpus
        AlchemyAPI.search(:concept_tagging, text: corpus.text)
            .map { |hit| hit.slice("text", "relevance", "website") }
    end

    def self.taxonomy corpus
        AlchemyAPI.search(:taxonomy, text: corpus.text)
    end

    def self.category corpus
        AlchemyAPI.search(:text_categorization, text: corpus.text).slice("category", "score")
    end

end