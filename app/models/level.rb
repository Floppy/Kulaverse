class Level < ActiveRecord::Base
  has_many :scores

  serialize :blocks
  serialize :start
  serialize :entities

end
