class ReadabilityService
    extend Service

    def self.flesch_kincaid_grade_level corpus
        FleschKincaidService.grade_level corpus
    end

    def self.flesch_kincaid_age_minimum corpus
        FleschKincaidService.age_minimum corpus
    end

    def self.flesch_kincaid_reading_ease corpus
        FleschKincaidService.reading_ease corpus
    end

end