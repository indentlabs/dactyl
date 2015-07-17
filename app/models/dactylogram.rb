class Dactylogram < ActiveRecord::Base
	attr_accessor :data

	SYLLABLE_COUNT_OVERRIDES = {
		'ion' => 2
	}

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

	def syllable_count_metric
		word_syllables.sum
	end

	def syllables_per_sentence_metric
		total_syllables = 0
		sentences.each do |sentence|
			total_syllables += sentence.split(' ').map(&method(:syllables_in)).sum
		end

		total_syllables.to_f / sentences.length
	end

	def unique_words_percentage_metric
		unique_words.length.to_f / words.length
	end

	def whitespace_percentage_metric
		occurrences(of: ["\s", "\r", "\n"], within: data.chars).to_f / data.length
	end

	def word_count_metric
		words.length
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

	def word_syllables
		words.map(&method(:syllables_in))
	end

	def syllables_in word
		word.downcase.gsub!(/[^a-z]/, '')

		return 1 if word.length <= 3
		return SYLLABLE_COUNT_OVERRIDES[word] if SYLLABLE_COUNT_OVERRIDES.key? word

		word.sub(/(?:[^laeiouy]es|ed|[^laeiouy]e)$/, '').sub!(/^y/, '')
		word.scan(/[aeiouy]{1,2}/).size
	end

	def occurrences of: needles, within: haystack
		of = [of] unless of.is_a? Array

		within.flatten.select { |hay| of.include? hay }.length
	end

end
