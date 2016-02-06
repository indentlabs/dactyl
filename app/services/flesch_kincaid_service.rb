class FleschKincaidService
	extend Service

	def self.grade_level words:, sentences:, word_syllables:
		#todo extract dem params
		[
            0.38 * (words.length.to_f / sentences.length),
            11.18 * (word_syllables.sum.to_f / words.length),
            -15.59
        ].sum
    end

end