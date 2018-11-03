require 'rubygems'

require 'jekyll'

# Send STDERR into the void to suppress program output messages
STDERR.reopen(test(?e, '/dev/null') ? '/dev/null' : 'NUL:')

require 'kramdown'
require 'nokogiri'

root = File.expand_path File.dirname(__FILE__)
require File.join(root, 'support', 'jekyll_config_dirs')

RSpec.configure do |config|

  config.mock_with :rspec

  config.include Jekyll
  config.include JekyllConfigDirs

  # These two settings work together to allow you to limit a spec run
  # to individual examples or groups you care about by tagging them with
  # `:focus` metadata. When nothing is tagged with `:focus`, all examples
  # get run.
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

end
