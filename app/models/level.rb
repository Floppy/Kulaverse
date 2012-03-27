class Level < ActiveRecord::Base
  belongs_to :world
  has_many :scores

  serialize :blocks
  serialize :start
  serialize :entities

  delegate :theme, :to => :world

end
