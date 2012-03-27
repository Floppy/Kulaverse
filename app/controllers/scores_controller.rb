class ScoresController < ApplicationController

  def create
    # Score is an integer
    new_score = params[:score].to_i
    # If user isn't logged in, just carry on without storing anything
    return if current_user.nil?
    # Find existing score
    @score = current_user.scores.where(:level_id => params[:level_id]).first
    if @score
      # Update score if higher
      @score.score = new_score if new_score > @score.score
      @score.save
    else
      # Create a new score record
      Score.create(:level_id => params[:level_id], :user => current_user, :score => new_score)
    end
  end

end
