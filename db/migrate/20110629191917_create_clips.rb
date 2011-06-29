class CreateClips < ActiveRecord::Migration
  def self.up
    create_table :clips do |t|
      t.integer :collection_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :clips
  end
end
