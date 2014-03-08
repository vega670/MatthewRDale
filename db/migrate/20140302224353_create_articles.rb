class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :url
      t.string :canonical_url
      t.string :rss_feed_url
      t.text :rss_item_json

      t.timestamps
    end
  end
end
