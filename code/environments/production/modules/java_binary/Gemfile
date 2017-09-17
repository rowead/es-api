source 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_VERSION') ? (ENV['PUPPET_VERSION']).to_s : ['>= 3.3']
gem 'facter', '>= 1.7.0'
gem 'librarian-puppet' , '>=2.0'
gem 'metadata-json-lint'
gem 'puppet', puppetversion
gem 'puppet-lint', '>= 1.0.0'
gem 'puppetlabs_spec_helper', '>= 0.8.2'
if RUBY_VERSION =~ /^1\.9\./ or RUBY_VERSION =~ /^1\.8\./
  gem 'fog-google', '< 0.1.1'
  gem 'json', '< 2.0' # newer versions requires at least ruby 2.0
  gem 'json_pure', '< 2.0.0'
end
if RUBY_VERSION < "2.1.0"
  gem 'nokogiri', '< 1.7.0'
end

group :development do
  gem 'puppet-blacksmith', '~> 3.0'
  gem 'rubocop'
end
