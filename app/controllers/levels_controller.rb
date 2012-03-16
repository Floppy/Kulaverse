class LevelsController < ApplicationController
  before_filter :get_world

  # GET /levels
  # GET /levels.json
  def index
    @levels = @world.levels

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @levels }
    end
  end

  # GET /levels/1
  # GET /levels/1.json
  def show
    @level = @world.levels.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @level }
    end
  end

  protected
  
  def get_world
    @world = World.find(:first)
  end

end
