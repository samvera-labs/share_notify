$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'share_notify'
require 'rspec/its'

def fixture_path
  File.join(ShareNotify.root, 'spec', 'fixtures')
end
