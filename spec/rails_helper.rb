# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
  
  config.include Capybara::DSL
  # config.include LoginHelper, :type => :feature

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
 

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end

def default_missing_message
  "can't be blank"
end

def default_duplicate_message
  "has already been taken"
end

def default_inclusion_message
  "is not included in the list"
end

def default_number_message
  "is not a number"
end

def default_format_message
  "is invalid"
end

def valid_archer
  Archer.create(
    username: "testuser", 
    email: "testuser@example.com", 
    password: "test", 
    first_name: "Test", 
    last_name: "User", 
    birthdate: "1980-07-01", 
    gender: "Male", 
    home_city: "Denver", 
    home_state: "CO", 
    home_country: "USA", 
    default_age_class: "Senior"
  )
end

def valid_score_session
  ScoreSession.create(
    name: "2020 World Cup", 
    score_session_type: "Tournament", 
    city: "Oxford", 
    state: "OH", 
    country: "USA", 
    start_date: "2020-09-01", 
    end_date: "2020-09-05", 
    rank: "1st", 
    active: true
  )
end

def valid_round
  Round.create(name: "1440 Round", discipline: "Outdoor", round_type: "Qualifying", num_roundsets: 4, user_edit: false)
end

def valid_round_set
  RoundSet.create(name: "1440 Round - Set/Distance1", ends: 6, shots_per_end: 6, score_method: "Points")
end

def valid_shot
  Shot.create(date: "2020-09-01", end_num: 5, shot_num: 5, score_entry: "5",  set_score: 2)
end

def valid_target
  Target.create(name: "122cm/1-spot/10-ring", size: "122cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: false)
end

def valid_category
  ArcherCategory.create(
    cat_code: "WA-RM", 
    gov_body: "World Archery", 
    cat_division: "Recurve", 
    cat_age_class: "Senior", 
    min_age: 21, 
    max_age: 49, 
    open_to_younger: true, 
    open_to_older: true, 
    cat_gender: "Male"
  )
end

def valid_dist_targ
  DistanceTarget.create(distance: "90m", target_id: 1, archer_category_id: 1, round_set_id: 1)
end



