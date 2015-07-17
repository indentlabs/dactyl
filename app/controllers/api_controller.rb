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

		d = Dactylogram.new(data: @analysis_string)
		d.instance_variable_set(:@metrics, params[:metrics].map { |m| "#{m}_metric" }) if params[:metrics].present?

		render :json => d.metric_report
	end
end
