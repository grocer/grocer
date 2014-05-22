ENV['RACK_ENV'] = 'test'

if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

require 'mocha/api'
require 'bourne'
require 'support/notification_helpers'
require 'grocer'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.mock_with :mocha

  config.include NotificationHelpers
end
