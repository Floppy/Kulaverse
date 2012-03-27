class LevelsController < ApplicationController
  before_filter :get_world

  def show
    @level = @world.levels.find(params[:id])
  end

  protected
  
  def get_world
    @world = World.find(params[:world_id])
  end

end
