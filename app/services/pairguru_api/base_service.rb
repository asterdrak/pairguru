module PairguruApi
  class BaseService
    attr_accessor :status, :data

    CACHE_DEFAULTS = { expires_in: 7.days }.freeze

    # rubocop:disable Lint/UriEscapeUnescape
    def self.find(id)
      new(*request.get(URI.escape(id), CACHE_DEFAULTS))
    end
    # rubocop:enable Lint/UriEscapeUnescape

    def initialize(response, status = nil)
      self.data = response[:data] || response
      self.status = status
    end

    def self.request
      EndpointRequestService.new(resource_name)
    end
  end
end
