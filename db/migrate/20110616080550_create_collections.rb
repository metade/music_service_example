class CreateCollections < ActiveRecord::Migration
  def self.up
    create_table :collections do |t|
      t.string :url_key
      t.string :pid
      t.string :title
      t.string :artists
      t.string :short_synopsis
      t.string :medium_synopsis
      t.string :url
      
      t.integer :user_id
      t.integer :featured_position
      t.integer :use_pips  # should be boolean
      t.integer :has_image # should be boolean
      t.datetime :promoted_at

      t.timestamps
    end
  end

  def self.down
    drop_table :collections
  end
end
