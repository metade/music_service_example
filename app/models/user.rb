class User < ActiveRecord::Base
  validates_presence_of :username
  validates_uniqueness_of :username
  
  has_many :collections
  has_many :playlists
  
  def to_param
    username
  end
end
