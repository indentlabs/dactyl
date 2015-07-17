class ApiController < ApplicationController

	before_action :set_analysis_string

	def set_analysis_string
		@analysis_string ||= begin
			if params[:url].present?
				"#todo: fetch text from remote url"
			end

			if params[:upload].present?
				"#todo: support file upload"
			end

			# Fall back on good ol' GET
			params[:string] || params[:text]
		end
	end

	def dactyl
		return unless @analysis_string.present?

		render :json => Dactylogram.new(data: @analysis_string).metrics
	end
end
