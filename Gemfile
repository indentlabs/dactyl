source 'https://rubygems.org'

# Architecture
gem 'rails', '~> 5.2'
gem 'puma'

# Authentication
gem 'devise'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-google'
gem 'omniauth-facebook'
# TODO: gem 'omniauth-indent'

# Base assets
gem 'sass-rails'
gem 'mini_racer'
gem 'uglifier'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'turbolinks'
gem 'rails-html-sanitizer'

# Icons
gem 'material_icons'

# Design
gem 'materialize-sass', '~> 1.0.0'
gem 'd3-rails'
gem 'd3-cloud-rails'

# NLP
gem 'birch', github: 'billthompson/birch', branch: 'birch-ruby22'
# can move back to treat core when https://github.com/louismullie/treat/issues/115 is resolved
gem 'treat', :git => 'https://github.com/indentlabs/treat-gem.git'
#gem 'stanford-core-nlp'
gem 'engtagger'
gem 'wordnet'
#gem 'wordnet-defaultdb'
gem 'sentimental'
gem 'alchemy-api-rb', :require => 'alchemy_api'

# Document uploading and parsing
gem 'ruby-rtf'
gem 'docx-html'
gem 'pdf-reader'
gem "nokogiri"

# Editor
gem 'medium-editor-rails'

# Quality of life
gem 'friendly_id'

# Development
group :development do
  gem 'web-console'
end

group :test do
  gem 'coveralls', require: false
  gem 'simplecov', require: false
end

group :development, :test do
  gem 'database_cleaner'
  gem 'factory_girl_rails', require: false
  gem 'pry'
  gem 'spring'
  gem 'sqlite3'
  #gem 'pg'
  gem 'byebug', '3.4.0'
end

# Production
group :production do
  gem 'pg'
end
