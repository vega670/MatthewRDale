 require 'addressable/uri'
require 'open-uri'
require 'json'

module Api
	class Steam
		def self.host
			'api.steampowered.com'
		end

		def self.scheme
			'https'
		end

		def self.api_key
			APP_CONFIG['steam_api_key']
		end

		def self.recently_played_games steam_id
			JSON.parse open(uri_for('GetRecentlyPlayedGames', {steamid: steam_id})).read
		end

		private
		def self.uri_for action, options
			query = {
				key: api_key,
				format: 'json'
			}
			path = '/IPlayerService/'
			version = '/v0001/'
			Addressable::URI.new(
				host: host,
				scheme: scheme,
				query_values: query.merge(options),
				path: path + action + version
			)
		end
	end
end
