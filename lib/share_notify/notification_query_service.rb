require 'share_notify/exceptions'

module ShareNotify
  # Queries the SHARE search api for an existing record. This assumes the class into which this
  # module is included responds to #url and that in turn is mapped to the docID of the Share
  # document that was originally uploaded via the SHARE push API.
  #
  # @see ShareNotify::PushDocument
  class NotificationQueryService
    def initialize(context)
      self.context = context
    end

    def share_notified?
      response = search("shareProperties.docID:\"#{context.url}\"")
      return if response.status != 200
      return false if response.count < 1
      response.docs.first.doc_id == context.url
    end

    private

      def search(string)
        ShareNotify::SearchResponse.new(api.search(string))
      end

      def api
        ShareNotify::API.new
      end

      attr_reader :context

      def context=(input)
        raise ShareNotify::InitializationError.new(input, [:url]) unless input.respond_to?(:url)
        @context = input
      end
  end
end
