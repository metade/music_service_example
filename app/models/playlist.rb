class Playlist < ActiveRecord::Base
  validates_presence_of :url_key
  validates_presence_of :user_id
  validates_uniqueness_of :url_key
  before_validation :generate_url_key
  
  belongs_to :user
  
  def to_param
    url_key
  end
  
  protected
  
  def generate_url_key
    self.url_key ||= (rand(26) + 65).chr + (rand(26) + 65).chr + (rand(26) + 65).chr + (rand(26) + 65).chr
  end
end
