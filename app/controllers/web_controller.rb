class WebController < ApplicationController

    skip_before_filter :verify_authenticity_token, :only => [:index]

    def index
        return unless @analysis_string.present?

        d = Dactylogram.new(data: @analysis_string)
        d.instance_variable_set(:@metrics, params[:metrics].map { |m| "#{m}_metric" }) if params[:metrics].present?

        @data = d.metric_report
    end

end
