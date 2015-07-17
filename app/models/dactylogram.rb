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

	def length_metric
		data.length
	end

	# ... more stuffs ... #

	private

	# Given a method name (symbol), return whether it should be ran as a metric
	def metric? method_name
		method_name.to_s.end_with? '_metric'
	end

	def calculate_metrics
		@metrics ||= all_metrics

		results = {}
		@metrics.map { |metric|
			results[metric.to_s.chomp '_metric'] = send(metric)
		}
		results
	end

end
