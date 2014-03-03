json.array!(@articles) do |article|
  json.extract! article, :id, :url, :feed_url
  json.url article_url(article, format: :json)
end
