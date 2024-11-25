class Steam::BaseClient
  def get(path, params = {})
    uri = URI([ self.class::API_URL, path ].join("/"))
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)
  rescue JSON::ParserError
    nil
  end
end
