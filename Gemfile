source 'https://rubygems.org'

# Architecture
gem 'rails', '4.2.5'

# Authentication
gem 'devise'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-google'
gem 'omniauth-facebook'
# TODO: gem 'omniauth-indent'

# Assets
gem 'sass-rails', '~> 5.0'
gem 'therubyracer'
gem 'uglifier'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'turbolinks'
gem 'rails-html-sanitizer'
gem 'material_icons'
gem 'font-awesome-rails'

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
gem 'ruby-rtf', '0.0.1'
gem 'docx-html', '~> 0.1.0'
gem 'pdf-reader', '1.3.3'
gem 'nokogiri', '~>1.6.7'

# Editor
gem 'medium-editor-rails'

# Development
group :development do
  gem 'web-console', '~> 2.0'
end

group :development, :test do
  gem 'database_cleaner'
  gem 'factory_girl_rails', '~> 4.0', require: false
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
