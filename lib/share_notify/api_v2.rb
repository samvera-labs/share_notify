class ShareNotify::ApiV2
  include HTTParty

  # Uncomment next line if you want the api calls to be written to STDOUT
  # debug_output $stdout

  attr_reader :headers, :response

  base_uri ShareNotify.config.fetch('host', 'https://staging-share.osf.io/')

  def initialize
    @headers = {
      'Authorization' => "Bearer #{ShareNotify.config.fetch('token')}",
      'Content-Type'  => 'application/vnd.api+json'
    }
  end

  # @return [HTTParty::Response]
  def get
    @response = with_timeout { self.class.get(api_data_point) }
  end

  # @return [HTTParty::Response]
  def post(body)
    @response = with_timeout { self.class.post(api_data_point, body: body, headers: headers) }
  end

  def upload_record(push_document)
    body = ShareNotify::Graph.new(push_document).to_share_v2.to_json
    post(body)
  end

  # @return [HTTParty::Response]
  def search(query)
    @response = with_timeout { self.class.get(api_search_point, query: { q: query }) }
  end

  private

    def api_data_point
      '/api/v2/normalizeddata/'
    end

    def api_search_point
      ##
    end

    def with_timeout(&_block)
      Timeout.timeout(5) { yield }
    end
end
