class WebController < ApplicationController
    include ParserHelper

    before_action :set_analysis_string
    def set_analysis_string
        @analysis_string ||= params[:string] || params[:text]
    end

    def index
        if (params.has_key?(:file) && params[:file].class == ActionDispatch::Http::UploadedFile)
            @analysis_string = parse_document params[:file]
            params[:file].close
        end

        if @analysis_string.present?
            corpus = Corpus.new text: @analysis_string
            corpus.save!

            d = Dactylogram.new(data: @analysis_string, corpus: corpus)
            d.instance_variable_set(:@metrics, params[:metrics].map { |m| "#{m}_metric" }) if params[:metrics].present?
            d.compute_metrics!
            d.save!

            redirect_to show_dactylogram_path(reference: d.reference)
        end
    end

    def upload
        return unless @analysis_string.present?

        d = Dactylogram.new(data: @analysis_string, identifier: params[:author])
        d.instance_variable_set(:@metrics, params[:metrics].map { |m| "#{m}_metric" }) if params[:metrics].present?
        d.send :calculate_metrics!

        #render json: d.save
    end

    def show
        d = Dactylogram.find_by(reference: params[:reference])

        # redirect_to 404 unless d
        @report = d.metric_report
        @report[:metrics] = metrics_by_category @report[:metrics]
    end

    private

    # Categorize all the metrics into groups to avoid printing out one big list to the user
    def metrics_by_category metrics
        # Converts Dactylogram metric format
        # {"FleschKincaidService::grade_level"=>-4.029999999999999, "FleschKincaidService::age_minimum"=>"", "FleschKincaidService::reading_ease"=>121.22000000000003}
        # to categorized-by-service format to pass to view
        # {"FleschKincaidService"=>[{"grade_level"=>-4.029999999999999}, {"age_minimum"=>""}, {"reading_ease"=>121.22000000000003}]}
        categorized_metrics = {}

        metrics.each do |key, value|
            category, method = key.split '::'

            categorized_metrics[category] ||= []
            categorized_metrics[category] << { method => value }
        end

        categorized_metrics
    end

end
