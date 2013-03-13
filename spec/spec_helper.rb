ENV['RACK_ENV'] = 'test'
require 'mocha/api'
require 'bourne'
require 'support/notification_helpers'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.mock_with :mocha

  config.include NotificationHelpers
end
