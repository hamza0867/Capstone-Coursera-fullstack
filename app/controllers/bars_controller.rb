class BarsController < ApplicationController
  before_action :set_bar, only: [:show, :update, :destroy]

  # GET /bars
  # GET /bars.json
  def index
    @bars = Bar.all
  end

  # GET /bars/1
  # GET /bars/1.json
  def show
  end

  # POST /bars
  # POST /bars.json
  def create
    @bar = Bar.new(bar_params)

    if @bar.save
      render :show, status: :created, location: @bar
    else
      render json: @bar.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /bars/1
  # PATCH/PUT /bars/1.json
  def update
    if @bar.update(bar_params)
      render :show, status: :ok, location: @bar
    else
      render json: @bar.errors, status: :unprocessable_entity
    end
  end

  # DELETE /bars/1
  # DELETE /bars/1.json
  def destroy
    @bar.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bar
      @bar = Bar.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bar_params
      params.require(:bar).permit(:name)
    end
end
