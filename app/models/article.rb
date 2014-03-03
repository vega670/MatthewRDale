require 'api/google_feed'
require 'uri'
require 'net/http'
require 'rss'
require 'levenshtein'

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
		content_from rss_item
	end

	def rss_feed
		xml = Net::HTTP.get URI(self.rss_feed_url)
		RSS::Parser.parse xml
	end

	def rss_item
		if self.rss_item_json.nil?
			ordered_items = rss_feed.items.sort do |item1, item2|
				distance_from(item1) <=> distance_from(item2)
			end
			self.rss_item_json = ordered_items.first.to_json
		end
		JSON.parse self.rss_item_json
	end

	def rss_feed_url
		self[:rss_feed_url] ||= Api::GoogleFeed.urls_for(site_name).first
	end

	private
	def populate!
		self.rss_item
	end

	def sanitize_path path
		Pathname.new(path).cleanpath.to_s.downcase
	end

	def content_from rss_item
		rss_hash = rss_item.as_json
		if rss_hash['description'].try(:length).to_i > rss_hash['content_encoded'].try(:length).to_i
			rss_hash['description']
		else
			rss_hash['content_encoded']
		end
	end

	def distance_from rss_item
		# do some light normalization of the URLs
		clean_url = sanitize_path self.url
		item_url = sanitize_path rss_item.link
		item_guid = sanitize_path rss_item.guid.to_s

		# find the sum of the distances between the RSS link URLs and the RSS GUIDs, which are sometimes (better) URLs
		distance = Levenshtein.distance(item_url, clean_url)
		distance += Levenshtein.distance(item_guid, clean_url)

		# knock off 20% of the distance if the original URL path is in the RSS body. 20% is arbitrary, but it seems OK
		if content_from(rss_item).downcase.include? sanitize_path(URI(self.url).path)
			distance -= distance * 0.2
		end

		distance
	end
end
