
slim_option = yes?("Install slim?")

def source_paths
  [File.join(File.expand_path(File.dirname(__FILE__)),'templates')] + Array(super)
end

log "removing turbolinks"
gsub_file "Gemfile", /^gem\s+["']turbolinks["'].*$/,''


log "Adding additional gems"
# Use postgresql as the database for Active Record
gem 'pg'
# Use Pry as your rails console
gem 'pry-rails'
# Angular.
gem 'angularjs-rails'
# Summary: Use ngannotate in the Rails asset pipeline.
gem 'ngannotate-rails'
# This adds ui-routes for improved routes
gem 'angular-ui-router-rails', git: 'https://github.com/iven/angular-ui-router-rails.git'

gem 'slim-rails' if slim_option

log "Adding additional develpment and test gems"
gem_group :development, :test do
  # RSpec for Rails
  gem 'rspec-rails'

  # Guard is a command line tool to easily handle events on file system modifications.
  gem 'guard', require: false

  # rspec command for spring
  gem 'spring-commands-rspec'

  # Guard::RSpec automatically run your specs (much like autotest).
  gem 'guard-rspec'

  # factory_girl_rails provides integration between
  # factory_girl and rails 3 (currently just automatic factory definition
  # loading)
  gem 'factory_girl_rails'

  # Better errors page
  gem "better_errors"
end

log "Inseting requre angular files and tags to application.js and applicaiton.html"
insert_into_file 'app/assets/javascripts/application.js', before: "//= require_tree" do
"//= require angular
//= require angular-animate
//= require angular-resource
//= require angular-ui-router
//= require angular/config\n"
end

log "removing turbolinks from aplication.js"
gsub_file "app/assets/javascripts/application.js", /\/\/= require turbolinks\n/,''
gsub_file "app/views/layouts/application.html.erb", /, 'data-turbolinks-track' => true/, ''

log "add ng-view and remove erb yield"
insert_into_file 'app/views/layouts/application.html.erb', "<ng-view></ng-view>", after: "<body>\n"
gsub_file "app/views/layouts/application.html.erb", /, '<%= yield %>/, ''

log "Insert support for ui-routes"
insert_into_file 'app/views/layouts/application.html.erb', "<div ui-view></div>", before: "\n</body>"

log "Create AngularJS directories and config file"
inside 'app/assets/javascripts/angular' do
  template 'config.coffee'
  
  inside 'controllers' do

  end
  inside 'factories' do

  end
  inside 'routes' do
    template 'routes.coffee'
  end
  inside 'services' do

  end
end

log "Remove test folder and add generator defaults"
insert_into_file 'config/application.rb', after: "# config.i18n.default_locale = :de\n" do
  "  config.generators do |g|
    g.stylesheets false
    g.test_framework :rspec
    g.fixture_replacement :factory_girl
  end\n"
end
run 'rm -r test/'

log "Create default controller"
inside 'app/controllers' do
  template 'layouts_controller.rb'
end

log "Add default route to routes.rb"
route "root to: 'layouts#index'"

after_bundle do
  if yes?("Setup Git and create initial commit?")
      log "Setting up git"
      git :init
      git add: "-A"
      git commit: %Q{ -m 'Initial commit' }
  else
    log "Skipping git"
  end

  run "spring stop"
  run "rails generate rspec:install"
  run "spring start"
end

