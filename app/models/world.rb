class World < ActiveRecord::Base
  has_many :levels
  validates :name, :presence => true, :uniqueness => true
end
