class Level < ActiveRecord::Base

  def blocks
    [
      [-1,0,-1],
      [0,0,-1],
      [1,0,-1],
      [-1,0,0],
      [1,0,0],
      [-1,0,1],
      [0,0,1],
      [1,0,1],
      [-1,1,0],
    ]
  end

end
