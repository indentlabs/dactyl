class ApiController < ApplicationController

    def dactyl
        @analysis_string ||= ""

        d = Dactylogram.new(corpus: Corpus.new(text: @analysis_string))
        d.instance_variable_set(:@metrics, params[:metrics].map { |m| "#{m}_metric" }) if params[:metrics].present?

        render json: d.metric_report
    end
end
