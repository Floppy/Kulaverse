source 'https://rubygems.org'

gem 'rails', '~> 6.0.1'

gem 'json'
gem 'devise'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'bootstrap-sass'
gem 'rails_admin'
gem 'high_voltage'
gem 'jquery-rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 6.0'
  gem 'coffee-rails', '~> 5.0'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'powder'
  gem 'af'
  gem 'caldecott'
end

group :development, :test do
  gem 'sqlite3'
  gem 'jasminerice'
  gem 'rspec-rails'
end

group :production do
  gem 'thin'
  gem 'mysql2'
end