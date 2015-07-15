# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

Rails.logger.level = Logger::ERROR

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cassette_library'
  c.hook_into :webmock
  c.default_cassette_options = { :record => :new_episodes }
  c.configure_rspec_metadata!
end

#development and test credentials
ENV["TWITTER_OAUTH_API_ID"]="2G3TwhdIjOMYN0ETjhQONRxUp"
ENV["TWITTER_OAUTH_API_SECRET"]="R4oD6mfOXZkMq9wt93SEl7INnYBC5otRiMGVoOPdhINgYVBmVB"
ENV["POCKET_CONSUMER_KEY"]="42980-f9f04843b3e6193ef4ca1245"

def sign_in(user)
  @token = Authentication::Token.new(user: user).create
end