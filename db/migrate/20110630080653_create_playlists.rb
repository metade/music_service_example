class CreatePlaylists < ActiveRecord::Migration
  def self.up
    create_table :playlists do |t|
      t.integer :user_id
      t.integer :status, :default => 0
      t.string :title
      t.string :medium_synopsis
      t.string :url_key
      t.string :short_synopsis
      
      t.datetime :promoted_at
      
      t.timestamps
    end
  end

  def self.down
    drop_table :playlists
  end
end
