class DactylogramController < ApplicationController
  include ParserHelper

  before_action :set_analysis_string
  def set_analysis_string
    @analysis_string ||= params[:string] || params[:text]

    if (params.has_key?(:file) && params[:file].class == ActionDispatch::Http::UploadedFile)
      @analysis_string = parse_document params[:file]
      params[:file].close
    end
  end

  def index
    # TODO
  end

  def new
    @dactylogram = Dactylogram.new
  end

  def create
    # TODO: clean this up
    return unless @analysis_string.present?

    #todo should probably break this out into separate post endpoint
    d = Dactylogram.new corpus: build_corpus_for(@analysis_string)
    d.instance_variable_set(:@metrics, params[:metrics].map { |m| "#{m}_metric" }) if params[:metrics].present?
    d.compute_metrics!
    d.save!

    redirect_to d
  end

  def upload
    # TODO: clean this up
    return unless @analysis_string.present?

    d = Dactylogram.new(corpus: build_corpus_for(@analysis_string), identifier: params[:author])
    d.instance_variable_set(:@metrics, params[:metrics].map { |m| "#{m}_metric" }) if params[:metrics].present?
    d.compute_metrics!
    d.save!
  end

  def show
    @dactyl = Dactylogram.find(params[:id])

    # TODO: redirect_to 404 unless d
    @report = @dactyl.metric_report
    @report[:metrics] = metrics_by_category @report[:metrics]
  end

  def destroy
    # TODO
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

  def build_corpus_for string
    corpus = Corpus.new text: @analysis_string
    corpus.save!
    corpus
  end
end
