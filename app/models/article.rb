require 'api/google_feed'
require 'uri'
require 'rss'
require 'levenshtein'
require 'parallel'
require 'open-uri'
require 'cgi'

class Article < ActiveRecord::Base
	validates :url, format: { with: URI::regexp }

	before_create :populate!

	def site_name
		host.split('.')[0..-2].reject {|part| part.include? 'www' }.join ' '
	end

	def host
		uri.host
	end

	def uri
		URI self.url
	end

	def canonical_url
		self[:canonical_url] ||= canonicalize_url self.url
	end

	def title
		CGI.unescapeHTML rss_item['title']
	end

	def content
		content_from rss_item
	end

	def rss_feed
		xml = open(self.rss_feed_url).read
		RSS::Parser.parse xml
	end

	def rss_item
		JSON.parse self.rss_item_json ||= begin
			distanced_items = Parallel.map(rss_feed.items, in_threads: 4) do |item|
				[item, distance_from(item)]
			end
			ordered_items = distanced_items.sort do |distanced1, distanced2|
				distanced1.last <=> distanced2.last
			end.map(&:first)
			ordered_items.first.to_json
		end
	end

	def rss_feed_url
		self[:rss_feed_url] ||= Api::GoogleFeed.urls_for(site_name).first
	end

	private
	def populate!
		self.rss_item
	end

	def canonicalize_url url
		canonical_url = follow_redirects url

		uri = URI canonical_url
		Pathname(uri.host.to_s + uri.path.to_s).cleanpath.to_s.downcase
	end

	def follow_redirects url
		return url unless url =~ /^#{URI::regexp}$/

		uri = URI(url)
		response = Net::HTTP.start(uri.host) do |http|
			http.head uri.path
		end

		location = response['location']
		if location.present?
			follow_redirects location
		else
			url
		end
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
		# find the sum of the distances between the all potential RSS URLs and the Article URL
		distance = [
			rss_item.link,
			rss_item.guid.to_s
		].map do |item_url|
			if item_url =~ /^#{URI::regexp}$/
				canonical_item_url = canonicalize_url item_url
				Levenshtein.distance(self.canonical_url, canonical_item_url)
			else
				0
			end
		end.reduce(:+)

		# knock off 20% of the distance if the original URL path is in the RSS body. 20% is arbitrary, but it seems OK
		if content_from(rss_item).downcase.include? URI(self.canonical_url).path
			distance -= distance * 0.2
		end

		distance
	end
end
