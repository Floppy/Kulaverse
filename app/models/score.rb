class Score < ActiveRecord::Base
  belongs_to :level
  belongs_to :user
  
  validates :level_id, :uniqueness => {:scope=>:user_id}
  
end
