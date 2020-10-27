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

# ##########################################################
# Necessary Pre-loads (by Model)
# ##########################################################

def before_archer
  valid_category
  valid_category_alt
  # puts "ran valid_category, which also ran: valid_gov_body, valid_discipline, valid_division, valid_age_class, valid_gender"
  # puts "ran valid_category_alt, which also ran: valid_gov_body_alt, valid_discipline_alt, valid_division_alt, valid_age_class_alt, valid_gender_alt"
end


def before_shot
  before_archer
  valid_archer
  valid_score_session
  valid_round
  valid_rset
  valid_end
end


# ##########################################################
# Default Error Messages (generated by Rails)
# ##########################################################
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

# ##########################################################
# Score Tracking Objects
# ##########################################################

def valid_archer
  # same as create below, except doesn't look for password
  archer = Archer.find_by(
    username: "validuser", 
    email: "validuser@example.com", 
    first_name: "Valid", 
    last_name: "Vuser", 
    birthdate: "1980-07-01", 
    gender: "Male", 
    home_city: "Denver", 
    home_state: "CO", 
    home_country: "USA", 
    default_age_class: "Senior", 
    default_division: "Recurve"
  )

  if !archer
    archer = Archer.create(
      username: "validuser",
      email: "validuser@example.com", 
      password: "test", 
      first_name: "Valid", 
      last_name: "Vuser", 
      birthdate: "1980-07-01", 
      gender: "Male", 
      home_city: "Denver", 
      home_state: "CO", 
      home_country: "USA", 
      default_age_class: "Senior", 
      default_division: "Recurve"
    )
  end
  archer
end

def valid_score_session
  ScoreSession.find_or_create_by(
    name: "2020 World Cup", 
    score_session_type: "Tournament", 
    city: "Oxford", 
    state: "OH", 
    country: "USA", 
    start_date: "2020-09-01", 
    end_date: "2020-09-05", 
    rank: "1st", 
    active: true, 
    archer: valid_archer
  )
end

def valid_round
  Round.find_or_create_by(name: "2020 World Cup - 1440 Round", round_type: "Qualifying", score_method: "Points", rank: "1st", archer: valid_archer, score_session: valid_score_session)
end


def valid_rset
  Rset.find_or_create_by(name: "1440 Round - Set/Distance1", date: "2020-09-01", rank: "1st", archer: valid_archer, score_session: valid_score_session, round: valid_round)
end

def valid_end
  End.find_or_create_by(number: 1, set_score: "", archer: valid_archer, score_session: valid_score_session, round: valid_round, rset: valid_rset)
end

# def valid_end_set
#   End.find_or_create_by(number: 1, set_score: 2)
# end

def valid_shot
  Shot.find_or_create_by(archer: valid_archer, score_session: valid_score_session, round: valid_round, rset: valid_rset, end: valid_end, number: 1, score_entry: "10")
end

# ##########################################################
# Organization Module Objects
# ##########################################################

def valid_gov_body
  Organization::GovBody.find_or_create_by(name: "World Archery", org_type: "International", geo_area: "Global")
end

def valid_gov_body_alt
  Organization::GovBody.find_or_create_by(name: "USA Archery", org_type: "National", geo_area: "United States")
end

def valid_discipline
  Organization::Discipline.find_or_create_by(name: "Outdoor")
end

def valid_discipline_alt
  Organization::Discipline.find_or_create_by(name: "Indoor")
end

def valid_division
  Organization::Division.find_or_create_by(name: "Recurve")
end

def valid_division_alt
  Organization::Division.find_or_create_by(name: "Compound")
end

def valid_age_class
  Organization::AgeClass.find_or_create_by(name: "Senior", min_age: 21, max_age: 49, open_to_younger: true, open_to_older: true)
end

def valid_age_class_alt
  Organization::AgeClass.find_or_create_by(name: "Junior", min_age: 18, max_age: 20, open_to_younger: true, open_to_older: false)
end

def valid_gender
  Organization::Gender.find_or_create_by(name: "Male")
end

def valid_gender_alt
  Organization::Gender.find_or_create_by(name: "Female")
end

def valid_category
  # Organization::ArcherCategory.create(cat_code: "WA-RM", gov_body_id: 1, discipline_id: 1, division_id: 1, age_class_id: 1, gender_id: 1)
  Organization::ArcherCategory.find_or_create_by(cat_code: "WA-RM", gov_body: valid_gov_body, discipline: valid_discipline, division: valid_division, age_class: valid_age_class, gender: valid_gender)
end

def valid_category_alt
  # Organization::ArcherCategory.create(cat_code: "WA-RJW", gov_body_id: 1, discipline_id: 1, division_id: 1, age_class: valid_age_class_junior, gender_id: valid_gender_female)
  Organization::ArcherCategory.find_or_create_by(cat_code: "WA-RM", gov_body: valid_gov_body_alt, discipline: valid_discipline_alt, division: valid_division_alt, age_class: valid_age_class_alt, gender: valid_gender_alt)
end

def valid_target
  Target.find_or_create_by(name: "122cm/1-spot/10-ring", size: "122cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: false)
  # Organization::Target.create(name: "122cm/1-spot/10-ring", size: "122cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: false)
end

def valid_dist_targ_cat
  DistanceTargetCategory.find_or_create_by(distance: "90m", target_id: 1, archer_category_id: 1, archer_id: 1)
  # Organization::DistanceTargetCategory.create(distance: "90m", target_id: 1, archer_category_id: 1, archer_id: 1)

  # DistanceTargetCategory.find_or_create_by(distance: "90m", target_id: 1, archer_category_id: valid_category, archer_id: valid_archer)
  # Organization::DistanceTargetCategory.create(distance: "90m", target_id: 1, archer_category_id: 1, archer_id: 1)
end

# ##########################################################
# Format Module Objects
# ##########################################################

def valid_round_format
  Format::RoundFormat.find_or_create_by(name: "1440 Round", num_sets: 4, user_edit: false)
end

def valid_set_end_format
  Format::SetEndFormat.find_or_create_by(name: "Set/Distance1", num_ends: 6, shots_per_end: 6, user_edit: false, round_format: valid_round_format)
end

