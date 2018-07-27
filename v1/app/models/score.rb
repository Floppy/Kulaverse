class Score < ActiveRecord::Base
  belongs_to :level
  belongs_to :user
end
