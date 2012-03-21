class Level < ActiveRecord::Base
  belongs_to :world

  serialize :blocks
  serialize :start
  serialize :entities

  delegate :theme, :to => :world

end
