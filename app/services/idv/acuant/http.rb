module Idv
  module Acuant
    module Http
      extend ActiveSupport::Concern

      included do
        include HTTParty
      end

      def get(url, options, &block)
        handle_response(self.class.get(url, options), block)
      end

      def post(url, options, &block)
        handle_response(self.class.post(url, options), block)
      end

      def handle_response(response, block)
        return [:error, response.message] unless success?(response)
        data = block ? block.call(response.body) : response.body
        [:success, data]
      end

      private

      def success?(response)
        response.code.between?(200, 299)
      end

      def accept_json
        { 'Accept' => 'application/json' }
      end

      def content_type_json
        { 'Content-Type' => 'application/json' }
      end

      def env
        Figaro.env
      end
    end
  end
end
