class FeedsCell < Cell::Rails
  require 'rss'
  require 'uri'
  require 'net/https'
  
  def project_updates
    uri = URI.parse("https://github.com/vega670.atom")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    
    @rss = RSS::Parser.parse(response.body)
    
    render
  end

  def games
    render
  end

  def music
    render
  end

end