module PairguruApi
  class MovieService < BaseService
    def method_missing(method)
      if respond_to?(method)
        data[method] || data.dig(:attributes, method)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      %i[plot rating poster type attributes title].include?(method_name) || super
    end

    def self.resource_name
      "movies"
    end
  end
end
