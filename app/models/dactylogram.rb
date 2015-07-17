class Dactylogram < ActiveRecord::Base
	attr_accessor :data

	def metric_report
		{
			original_string: data,
			metrics: calculate_metrics
		}
	end

	def all_metrics
		self.class.instance_methods.select { |m| metric? m }
	end

	def average_sentence_length_metric
		data.length.to_f / sentences.length
	end

	def data_length_metric
		data.length
	end

	def sentences_metric
		sentences.length
	end

	def spaces_after_sentence_metric
		spaces_per_sentence = sentences.map { |sentence|
			sentence.length - sentence.lstrip.length
		}.sum.to_f / (sentences.length - 1)
	end

	def unique_words_percentage_metric
		unique_words.length.to_f / words.length
	end

	def words_per_sentence_metric
		words.length.to_f / sentences.length
	end

	# ... more stuffs ... #

	private

	# Given a method name (symbol), return whether it should be ran as a metric
	def metric? method_name
		method_name.to_s.end_with? '_metric'
	end

	def calculate_metrics
		results = {}
		(@metrics || all_metrics).map { |metric|
			results[metric.to_s.chomp '_metric'] = send(metric)
		}
		results
	end

	def sentences
		data.split(/[!\?\.]/)
	end

	def words
		data.gsub(/[^\s\w]/, '').split(' ')
	end

	def unique_words
		words.map(&:downcase).uniq
	end
end
