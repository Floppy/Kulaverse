source 'https://rubygems.org'

gem 'rails', '~> 3.2'

gem 'json'
gem 'devise'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'bootstrap-sass'
gem 'rails_admin', :git => 'git://github.com/sferik/rails_admin.git'
gem 'high_voltage'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2'
  gem 'coffee-rails', '~> 3.2'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

group :development do
  gem 'powder'
  gem 'heroku'
end

group :development, :test do
  gem 'sqlite3'
  gem 'jasminerice'
  gem 'rspec-rails'
end

group :production do
  gem 'pg'
end