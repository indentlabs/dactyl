class LanguageService
    extend Service

    def self.language corpus
        AlchemyAPI.search(:language_detection, text: corpus.text)
            .slice("language", "native-speakers")
    end

    def self.dialect corpus
        #todo
    end

    def self.active_voice_percentage corpus
        #todo
    end

    def self.passive_voice_percentage corpus
        #todo
    end

end