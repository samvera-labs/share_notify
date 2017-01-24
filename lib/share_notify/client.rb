require 'net/http'
require 'set'
require 'json'
require 'securerandom'

module ShareNotify::Client
  class GraphNode

    attr_reader :id,
                :type,
                :attrs,
                :relations

    def initialize(type, **attrs)
      @id = '_:' + SecureRandom.uuid
      @type = type
      @relations = {}
      @attrs = attrs

      @attrs.each do |key, value|
        if value.is_a? GraphNode or value.is_a? Array
          @relations[key] = value
        end
      end

    end

    def ref()
      {'@id': @id, '@type': @type}
    end

    def serialize()
      self.ref.merge(@attrs).merge(Hash[@relations.map {|k, v|
        if v.is_a? Array
          [k, v.map {|x| x.ref}]
        else
          [k, v.ref]
        end
      }])
    end

    def related()
      @relations.map {|k, v| v}.flatten
    end

  end


  class Graph

    attr_reader :nodes

    def initialize(nodes=[])
      @nodes = nodes
    end

    def serialize()
      graph = []
      visited = Set.new
      to_visit = Set.new @nodes

      while not to_visit.empty?
        node = to_visit.to_a[0]
        to_visit.delete(node)

        if visited.include? node
          next
        end

        visited.add(node)
        to_visit.merge(node.related)
        graph.push(node.serialize)
      end

      {"data" => {"type" => 'NormalizedData',"attributes" => {"data" => {"@graph"=> graph}}}}
    end

  end
end