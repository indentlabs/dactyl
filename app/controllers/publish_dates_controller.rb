class PublishDatesController < ApplicationController
  before_action :set_publish_date, only: [:show, :edit, :update, :destroy]

  # GET /publish_dates
  def index
    @publish_dates = PublishDate.all
  end

  # GET /publish_dates/1
  def show
  end

  # GET /publish_dates/new
  def new
    @publish_date = PublishDate.new
  end

  # GET /publish_dates/1/edit
  def edit
  end

  # POST /publish_dates
  def create
    @publish_date = PublishDate.new(publish_date_params)

    if @publish_date.save
      redirect_to @publish_date, notice: 'Publish date was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /publish_dates/1
  def update
    if @publish_date.update(publish_date_params)
      redirect_to @publish_date, notice: 'Publish date was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /publish_dates/1
  def destroy
    @publish_date.destroy
    redirect_to publish_dates_url, notice: 'Publish date was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_publish_date
      @publish_date = PublishDate.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def publish_date_params
      params.require(:publish_date).permit(:published_at)
    end
end
