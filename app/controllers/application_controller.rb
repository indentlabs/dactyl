class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

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
