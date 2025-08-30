module ExternalApi
  class KingBooksService
    BASE_URL = "https://stephen-king-api.onrender.com"

    def initialize
      @connection = Faraday.new(url: BASE_URL) do |conn|
        conn.request :url_encoded
        conn.response :json, content_type: /\bjson$/
        conn.adapter Faraday.default_adapter
      end
    end

    def search_by_id(id)
      response = @connection.get("/api/short/#{id}")

      if response.success?
        { "data" => response.body["data"], "errors" => [] }
      else
        { "data" => nil, "errors" => [ "Book not found" ] }
      end
    end
  end
end
