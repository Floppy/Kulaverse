class LevelsController < ApplicationController
  # GET /levels
  # GET /levels.json
  def index
    @levels = Level.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @levels }
    end
  end

  # GET /levels/1
  # GET /levels/1.json
  def show
    @level = Level.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @level }
    end
  end

end
