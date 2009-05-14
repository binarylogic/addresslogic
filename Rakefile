ENV['RDOCOPT'] = "-S -f html -T hanna"

require "rubygems"
require "hoe"
require File.dirname(__FILE__) << "/lib/addresslogic/version"

Hoe.new("Addresslogic", Addresslogic::Version::STRING) do |p|
  p.name = "addresslogic"
  p.rubyforge_name = "addresslogic"
  p.author = "Ben Johnson of Binary Logic"
  p.email  = 'bjohnson@binarylogic.com'
  p.summary = "Easily display addresses."
  p.description = "Easily display addresses."
  p.url = "http://github.com/binarylogic/addresslogic"
  p.history_file = "CHANGELOG.rdoc"
  p.readme_file = "README.rdoc"
  p.extra_rdoc_files = ["CHANGELOG.rdoc", "README.rdoc"]
  p.remote_rdoc_dir = ''
  p.test_globs = ["test/*/test_*.rb", "test/*_test.rb", "test/*/*_test.rb"]
end