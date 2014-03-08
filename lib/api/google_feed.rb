require 'addressable/uri'
require 'open-uri'
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
			JSON.parse open(uri_for('find', {q: query})).read
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