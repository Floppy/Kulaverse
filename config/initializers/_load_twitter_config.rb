# Load from env vars (for heroku)
$twitter_consumer_key = ENV['TWITTER_CONSUMER_KEY']
$twitter_consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
# If env vars are empty, load from config file
if $twitter_consumer_key.nil? || $twitter_consumer_secret.nil?
  conf = YAML.load_file("#{Rails.root}/config/twitter.yml")[Rails.env]
  $twitter_consumer_key = conf['consumer_key']
  $twitter_consumer_secret = conf['consumer_secret']
end
