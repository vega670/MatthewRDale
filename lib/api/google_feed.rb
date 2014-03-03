require 'addressable/uri'
require 'net/http'
require 'json'

module Api
	class GoogleFeed
		def self.host
			'ajax.googleapis.com'
		end

		def self.scheme
			'https'
		end

		def self.find query
			JSON.parse Net::HTTP.get(uri_for 'find', {q: query})
		end

		def self.urls_for query
			begin
				find(query)['responseData']['entries'].map {|entry| entry['url'] }
			rescue Exception => e
				[]
			end
		end

		private
		def self.uri_for action, options
			query = {v: '1.0'}
			path = '/ajax/services/feed/'
			Addressable::URI.new(
				host: host,
				scheme: scheme,
				query_values: query.merge(options),
				path: path + action
			)
		end
	end
end