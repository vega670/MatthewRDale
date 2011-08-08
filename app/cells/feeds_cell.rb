class FeedsCell < Cell::Rails
  require 'rss'
  require 'uri'
  require 'net/https'
  require 'xml'
  
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
    url = 'http://steamcommunity.com/id/vega670/?xml=1'
    xml_data = Net::HTTP.get_response(URI.parse(url)).body
    parser, parser.string = XML::Parser.new, xml_data
    doc, statuses = parser.parse, []
    
    @games = Array.new
    doc.find('//profile/mostPlayedGames/mostPlayedGame').each do |game|
      @games << { :logo => game.find('gameLogo').first.content, :link => game.find('gameLink').first.content }
    end
    
    render
  end

end
