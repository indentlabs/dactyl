class ConjunctionsMetric < Metric
	attr_reader :conjunctions

	def word_aggregator word
		conjunctions << word
	end

end