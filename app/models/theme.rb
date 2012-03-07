class Theme < ActiveRecord::Base
  validates :name, :uniqueness => true
end
