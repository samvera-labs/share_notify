class ShareNotify::ApiV2
  include HTTParty

  # Uncomment next line if you want the api calls to be written to STDOUT
  # debug_output $stdout

  attr_reader :headers, :response

  base_uri ShareNotify.config.fetch('host', 'https://staging.osf.io')

  # @param [String] token is optional but some actions will not be successful without it
  def initialize(_token = nil)
    @headers = {
      'Authorization' => "Bearer #{ShareNotify.config.fetch('token', nil)}",
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
