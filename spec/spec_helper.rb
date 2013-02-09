require 'rubygems'

require 'jekyll'

# Send STDERR into the void to suppress program output messages
STDERR.reopen(test(?e, '/dev/null') ? '/dev/null' : 'NUL:')

require 'RedCloth'
require 'rdiscount'
require 'kramdown'
require 'redcarpet'

require 'nokogiri'

root = File.expand_path File.dirname(__FILE__)
require File.join(root, 'support', 'jekyll_config_dirs')

RSpec.configure do |config|

  config.mock_with :rspec

  config.include Jekyll
  config.include JekyllConfigDirs

  # def clear_dest
  #   FileUtils.rm_rf(dest_dir)
  # end

end
