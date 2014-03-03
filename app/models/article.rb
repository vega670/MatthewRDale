require 'api/google_feed'
require 'uri'
require 'net/http'
require 'rss'

class Article < ActiveRecord::Base
	validates :url, format: { with: URI::regexp }

	before_create :populate!

	def site_name
		host.split('.')[-2]
	end

	def host
		uri.host
	end

	def uri
		URI self.url
	end

	def title
		rss_item['title']
	end

	def content
		rss_item['description']
	end

	def rss_feed
		xml = Net::HTTP.get URI(self.rss_feed_url)
		RSS::Parser.parse xml
	end

	def rss_item
		self.rss_item_json ||= rss_feed.items.find do |item|
			item_uri = URI item.link
			item_uri.host == uri.host && 
				Pathname.new(item_uri.path).cleanpath == Pathname.new(uri.path).cleanpath
		end.to_json
		JSON.parse self.rss_item_json
	end

	def rss_feed_url
		self[:rss_feed_url] ||= Api::GoogleFeed.urls_for(site_name).first
	end

	private
	def populate!
		self.rss_item
	end
end
