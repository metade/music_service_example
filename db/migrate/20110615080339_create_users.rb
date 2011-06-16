class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username
      t.string :name
      t.string :bbcid
      t.string :brand_pid
      t.string :short_synopsis
      t.string :medium_synopsis
      t.string :artist_gid
      t.integer :featured_position
      t.integer :status
      t.integer :is_guide, :default => 0
      t.integer :is_superuser, :default => 0
      
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
