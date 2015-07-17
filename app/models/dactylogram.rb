class Dactylogram < ActiveRecord::Base
	attr_accessor :data

	def metrics
		{
			original_string: data,
		}
	end
end
