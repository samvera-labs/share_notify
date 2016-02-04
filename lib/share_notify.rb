require 'share_notify/version'
require 'active_support'
require 'active_support/core_ext'
require 'httparty'

module ShareNotify
  autoload :API,            'share_notify/api'
  autoload :Metadata,       'share_notify/metadata'
  autoload :PushDocument,   'share_notify/push_document'
  autoload :SearchResponse, 'share_notify/search_response'

  class << self
    def configure(value)
      if value.nil? || value.is_a?(Hash)
        @config = value
      elsif value.is_a?(String)
        @config = YAML.load(File.read(value))
      else
        fail InitializationError, "Unrecognized configuration: #{value.inspect}"
      end
    end

    def config
      if @config.nil?
        configure(File.join(root.to_s, 'config', 'share_notify.yml'))
      end
      @config
    end

    def root
      File.dirname(__dir__)
    end
  end
end
