source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'
# Use mysql2 as the database for Active Record
gem 'mysql2'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

# Use ActiveStorage variant
gem 'mini_magick'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap'

# https://github.com/twbs/bootstrap-rubygem
gem 'bootstrap'
gem 'jquery-rails'

gem 'ransack'

gem 'selenium-webdriver'
gem 'delayed_job_active_record'
gem 'progress_job'
gem 'haml'
gem 'pagy'

# Flexible authentication solution for Rails with Warden
gem 'devise'

# Object oriented authorization for Rails applications
gem 'pundit'

# LoadError in BooksController#index
# Generating image variants require the image_processing gem.
# Please add `gem 'image_processing', '~> 1.2'` to your Gemfile.
gem 'image_processing', '~> 1.2'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # for debugging
  gem 'debase', '0.2.5.beta2'
  gem 'ruby-debug-ide'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console'
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'webdrivers'
end
