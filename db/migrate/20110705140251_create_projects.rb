class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.string :source_link
      t.string :live_link
      t.string :client
      t.date :completed
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
