require 'share_notify/version'
require 'active_support'
require 'active_support/core_ext'
require 'httparty'

module ShareNotify
  autoload :API,            'share_notify/api'
  autoload :Metadata,       'share_notify/metadata'
  autoload :PushDocument,   'share_notify/push_document'
  autoload :SearchResponse, 'share_notify/search_response'
  autoload :Graph,          'share_notify/graph'
  autoload :NotificationQueryService, 'share_notify/notification_query_service'

  class << self
    def configure(value)
      if value.nil? || value.is_a?(Hash)
        @config = value
      elsif value.is_a?(String)
        @config = YAML.safe_load(File.read(value))
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
      return File.dirname(__dir__) unless defined?(Rails)
      Rails.root
    end
  end
end
