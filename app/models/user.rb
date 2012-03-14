class User < ActiveRecord::Base

  devise :omniauthable, :registerable, :rememberable, :trackable

  attr_accessible :name, :twitter_id, :remember_me

  def self.find_for_twitter_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info
    if user = User.where(:twitter_id => data.id).first
      user
    else
      User.create!(:name => data.screen_name, :twitter_id => data.id)
    end
  end
  
end
