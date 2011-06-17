class CreateCollections < ActiveRecord::Migration
  def self.up
    create_table :collections do |t|
      t.string :url_key
      t.string :title
      t.string :pid
      t.string :short_synopsis
      t.string :medium_synopsis
      t.integer :user_id
      t.integer :featured_position
      t.datetime :promoted_at

      t.timestamps
    end
  end

  def self.down
    drop_table :collections
  end
end
