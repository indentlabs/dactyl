class ApiController < ApplicationController

	before_action :set_analysis_string

	def set_analysis_string
		@analysis_string ||= begin
			fetch_remote_text   if params[:url].present?
			fetch_file_contents if params[:upload].present?

			params[:string] || params[:text]
		end
	end

	def dactyl
		return unless @analysis_string.present?

		d = Dactylogram.new(data: @analysis_string)
		d.instance_variable_set(:@metrics, params[:metrics].map { |m| "#{m}_metric" }) if params[:metrics].present?

		render :json => d.metric_report
	end

	private

	def fetch_file_contents file_upload
		"#todo support file upload"
	end

	def fetch_remote_text url
		"#todo support remote text fetching"
	end
end
