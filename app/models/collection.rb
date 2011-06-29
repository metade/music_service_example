class Collection < ActiveRecord::Base
  validates_presence_of :user_id
  validates_presence_of :url_key
  before_validation :generate_url_key
  
  has_many :clips
  belongs_to :user
  
  protected
  
  def generate_url_key
    self.url_key ||= (rand(26) + 65).chr + (rand(26) + 65).chr + (rand(26) + 65).chr + (rand(26) + 65).chr
  end
end
