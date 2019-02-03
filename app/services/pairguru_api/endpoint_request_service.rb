module PairguruApi
  class EndpointRequestService
    attr_reader :resource_name

    BASE_URL = "https://pairguru-api.herokuapp.com/api/v1".freeze

    def initialize(resource_name)
      @resource_name = resource_name
    end

    def connection
      @connection ||= Faraday.new(url: BASE_URL + "/" + resource_name)
    end

    def get(id, cache_params)
      response = Rails.cache.fetch("#{resource_name}-#{id}", cache_params) do
        connection.get(id)
      end

      [JSON.parse(response.body).deep_symbolize_keys, response.status]
    rescue Faraday::ConnectionFailed => e
      [{ message: e.message }, 404]
    end
  end
end
