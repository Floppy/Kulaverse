class LevelsController < ApplicationController
  before_filter :get_world

  def index
    @levels = Level.where(:world_num => @world)
  end

  def show
    @level = Level.where(:level_num => params[:id].to_i, :world_num => @world).first
  end

  protected
  
  def get_world
    @world = params[:world_id]
  end

end
