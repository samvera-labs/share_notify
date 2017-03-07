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
      return false unless contributor.keys.include?(:name)
      @contributors << contributor
    end

    # @param [Hash] publisher containing required keys for publisher
    def publisher=(publisher)
      return false unless publisher.keys.include?(:name)
      @publisher = publisher
    end

    # @param [Array<String>] languages list of languages
    def languages=(languages)
      return false unless languages.is_a?(Array)
      @languages = languages
    end

    # @param [Array<String>] tags list of tags
    def tags=(tags)
      return false unless tags.is_a?(Array)
      @tags = tags
    end

    # @param [Array<String>] related_agents list of agents
    def related_agents=(related_agents)
      return false unless related_agents.is_a?(Array)
      related_agents.each do |agent|
        return false unless agent.keys.include?(:agent_type) && agent.keys.include?(:type)&& agent.keys.include?(:name)
      end
      @related_agents = related_agents
    end

    # @param [Hash] extra 
    def extra=(extra)
      return false unless extra.is_a?(Hash)
      @extra = extra
    end

    def to_share
      { jsonData: self }
    end

    def delete
      @otherProperties = [OtherProperty.new("status", status: ["deleted"])]
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
        @properties = args.shift
      end
    end
  end
end
