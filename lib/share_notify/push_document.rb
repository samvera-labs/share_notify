# frozen_string_literal: true

require 'net/http'

module ShareNotify
  class PushDocument
    attr_reader :uris,
                :contributors,
                :providerUpdatedDateTime,
                :version,
                :publisher,
                :languages,
                :tags,
                :related_agents,
                :extra,
                :otherProperties
    attr_accessor :title,
                  :description,
                  :type,
                  :date_published,
                  :rights

    # @param [String] uri that identifies the resource
    def initialize(uri, datetime = nil)
      datetime = datetime.is_a?(Time) || datetime.is_a?(DateTime) ? datetime : Time.now
      @uris = ShareUri.new(uri)
      @providerUpdatedDateTime = datetime.utc.strftime('%Y-%m-%dT%H:%M:%SZ')
      @contributors = []
    end

    def valid?
      !(title.nil? || contributors.empty?)
    end

    def updated
      @providerUpdatedDateTime
    end

    # @param [DateTime or Time] time object that can be formatted in to the correct representation
    def updated=(time)
      return unless time.respond_to?(:strftime)
      @providerUpdatedDateTime = time.utc.strftime('%Y-%m-%dT%H:%M:%SZ')
    end

    # @param [String] version identifying the version of the resource
    def version=(version)
      @version = { versionId: version }
    end

    # @param [Hash] contributor containing required keys for description
    def add_contributor(contributor)
      return false unless contributor.key?(:name)
      @contributors << contributor
    end

    # @param [Hash] publisher containing required keys for publisher
    def publisher=(publisher)
      return unless publisher.key?(:name)
      @publisher = publisher
    end

    # @param [Array<String>] languages list of languages
    def languages=(languages)
      return unless languages.is_a?(Array)
      @languages = languages
    end

    # @param [Array<String>] tags list of tags
    def tags=(tags)
      return unless tags.is_a?(Array)
      @tags = tags
    end

    # @param [Array<String>] related_agents list of agents
    def related_agents=(related_agents)
      return unless related_agents.is_a?(Array)
      return unless related_agents.all? do |agent|
        agent.key?(:agent_type) && agent.key?(:type) && agent.key?(:name)
      end
      @related_agents = related_agents
    end

    # @param [Hash] extra
    def extra=(extra)
      return unless extra.is_a?(Hash)
      @extra = extra
    end

    # return data formatted for V1 of the SHARE API.
    def to_share
      { jsonData: self }
    end

    def delete
      @otherProperties = [OtherProperty.new("is_deleted", true)]
    end

    # has this object been marked as deleted?
    #
    # This crazy check is to maintain V1 compatibility.
    # There is no way to inspect the @properties attribute in otherProperties
    # so we settle for checking whether otherProperties contains any kind of "status".
    # A boolean attribute would be simpler.
    def deleted?
      !otherProperties.nil? && otherProperties.any? do |p|
        p.name == "is_deleted"
      end
    end

    class ShareUri
      attr_reader :canonicalUri, :providerUris

      def initialize(uri)
        @canonicalUri = uri
        @providerUris = [uri]
      end
    end

    class OtherProperty
      attr_reader :name, :property

      def initialize(*args)
        @name = args.shift
        # n.b. the attr_reader is for :property, not properties
        @properties = args.shift
      end
    end
  end
end
