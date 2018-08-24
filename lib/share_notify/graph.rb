# frozen_string_literal: true

module ShareNotify
  class Graph
    attr_reader :id,
                :type,
                :push_doc

    def initialize(push_doc)
      @id = calc_id("creativework|" + push_doc.title)
      @type = push_doc.type || 'CreativeWork'
      @push_doc = push_doc
    end

    def to_share_v2
      graph = (creative_work << workidentifer << tags << related_agents).flatten
      { "data" => { "type" => 'NormalizedData', "attributes" => { "data" => { "@graph" => graph } } } }
    end

    def creative_work
      # @id and @type are required fields which is declared in initialize
      creative_work = type_id
      add_property(creative_work, :rights, push_doc.rights)
      add_property(creative_work, :title, push_doc.title)
      add_property(creative_work, :description, push_doc.description)
      # convert v1 array to v2 string type for language
      add_language_property(creative_work, :language, push_doc.languages)
      add_property(creative_work, :date_published, push_doc.date_published)
      add_property(creative_work, :date_updated, push_doc.providerUpdatedDateTime)
      add_property(creative_work, :extra, push_doc.extra)
      creative_work[:is_deleted] = push_doc.deleted?

      [creative_work]
    end

    def related_agents
      return [] if push_doc.related_agents.nil?

      agent_results = []
      push_doc.related_agents.each do |agent|
        agent_id = calc_id("agent|" + agent[:name])
        agent_type_id = calc_id("agent_type|" + @id + agent[:name])

        agent_result = [
          type_id(agent_id, agent[:type]).merge(agent.except(:agent_type, :type)),
          type_id(agent_type_id, agent[:agent_type]).merge(agent: type_id(agent_id, agent[:type])).merge(creative_work_hash)
        ]
        agent_results << agent_result
      end
      agent_results.flatten
    end

    def workidentifer
      uri = push_doc.uris.canonicalUri
      uri_id = calc_id("workidentifier|#{uri}")
      type_id(uri_id, "WorkIdentifier").merge(uri: uri).merge(creative_work_hash)
    end

    def tags
      return [] if push_doc.tags.nil?

      tags_results = []
      push_doc.tags.each do |tag|
        tag_id = calc_id("tag|" + tag)
        throughtags_id = calc_id("throughtags|" + @id + tag)

        tag_result = [
          type_id(tag_id, "Tag").merge(name: tag),
          type_id(throughtags_id, "ThroughTags").merge(tag: type_id(tag_id, "Tag")).merge(creative_work_hash)
        ]
        tags_results << tag_result
      end
      tags_results.flatten
    end

    private

      def type_id(id = @id, type = @type)
        { :@id => id, :@type => type }
      end

      def creative_work_hash
        { creative_work: type_id }
      end

      def except(*keys)
        dup.except!(*keys)
      end

      # calc_id returns the "blank node id" for the given name.
      # A hash function is used, so a given name will always return the same id.
      def calc_id(name)
        "_:#{Digest::MD5.hexdigest(name)}"
      end

      def add_property(hsh, key, value)
        hsh[key] = value unless value.nil?
      end

      def add_language_property(hsh, key, value)
        hsh[key] = value.join(",") unless value.nil?
      end
  end
end
