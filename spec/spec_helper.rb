$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'share_notify'
require 'rspec/its'
require 'byebug' unless ENV['TRAVIS']
require 'factory_girl'
require 'factories'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

def fixture_path
  File.join(ShareNotify.root, 'spec', 'fixtures')
end
