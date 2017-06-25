# frozen_string_literal: true

require 'bundler/setup'
require 'elastic_map'
require 'rspec/its'
require 'byebug'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.mock_with :rspec
  config.order = :random
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# TODO: move this code into spec helper
class UsersIndex < ElasticMap::Index
  field :username
end

class UsersProfileIndex < ElasticMap::Index
  indexed_in :profile
end
