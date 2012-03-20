class Level < ActiveRecord::Base
  belongs_to :world

  delegate :theme, :to => :world

  def blocks
    [
      [-1,0,-1],
      [0,0,-1],
      [1,0,-1],
      [-1,0,0],
      [1,0,0],
      [4,0,0],
      [-1,0,1],
      [0,0,1],
      [1,0,1],
      [-1,1,0],
      [4,-1,0],
      [4,-2,0],
      [3,-2,0],
      [2,-2,0],
      [1,-2,0],
      [0,-2,0],
      [-1,-2,0],
      [-1,-1,0],
    ]
  end
  
  def start
    {
      :position => [1,0,0],
      #:orientation => [0,0,1]
    }
  end

  def entities
    [
      {
        :object => Entity.find_by_name('Finish'),
        :position => [4, 0, 0]
      },
      {
        :object => Entity.find_by_name('Coin'),
        :position => [1, 0, 1]
      },
      {
        :object => Entity.find_by_name('Coin'),
        :position => [1, 0, -1]
      },
      {
        :object => Entity.find_by_name('Coin'),
        :position => [-1, 0, 1]
      },
      {
        :object => Entity.find_by_name('Coin'),
        :position => [-1, 0, -1]
      }
    ]
  end

end
