# Load from env vars (for heroku)
$facebook_consumer_key = ENV['FACEBOOK_CONSUMER_KEY']
$facebook_consumer_secret = ENV['FACEBOOK_CONSUMER_SECRET']
# If env vars are empty, load from config file
if $facebook_consumer_key.nil? || $facebook_consumer_secret.nil?
  conf = YAML.load_file("#{Rails.root}/config/facebook.yml")[Rails.env]
  $facebook_consumer_key = conf['consumer_key']
  $facebook_consumer_secret = conf['consumer_secret']
end
