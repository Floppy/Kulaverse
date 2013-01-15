class User < ActiveRecord::Base

  has_many :scores

  devise :omniauthable, :registerable, :rememberable, :trackable

  attr_accessible :name, :twitter_id, :facebook_id, :remember_me, :avatar_url

  def self.find_for_twitter_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info
    user = User.where(:twitter_id => data.id).first || User.create!(:twitter_id => data.id)
    user.update_attributes(:name => data.screen_name, :avatar_url => data.profile_image_url_https)
    user
  end
  
  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    user = User.where(:facebook_id => access_token.uid).first || User.create!(:facebook_id => access_token.uid)
    user.update_attributes!(:name => access_token.info.name, :avatar_url => access_token.info.image)
    user
  end

  def completed_level?(world, level)
    scores.where(:level_num => level, :world_num => world).first.present?
  end
  
end
