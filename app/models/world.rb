class World < ActiveRecord::Base
  belongs_to :theme
  has_many :levels

  validates :name, :presence => true, :uniqueness => true
end
