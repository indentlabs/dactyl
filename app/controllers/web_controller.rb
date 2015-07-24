class WebController < ApplicationController

    skip_before_filter :verify_authenticity_token, :only => [:index]

    def index
        return unless @analysis_string.present?

        d = Dactylogram.new(data: @analysis_string)
        d.instance_variable_set(:@metrics, params[:metrics].map { |m| "#{m}_metric" }) if params[:metrics].present?

        @data = d.metric_report
    end

    #todo move this + api controller into concern
    before_action :set_analysis_string

    def set_analysis_string
        @analysis_string ||= begin
            fetch_remote_text   if params[:url].present?
            fetch_file_contents if params[:upload].present?

            params[:string] || params[:text]
        end
    end

    private

    def fetch_file_contents file_upload
        "#todo support file upload"
    end

    def fetch_remote_text url
        "#todo support remote text fetching"
    end
end
