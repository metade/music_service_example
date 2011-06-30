class Clip < ActiveRecord::Base
  validates_presence_of :pid
  validates_presence_of :collection_id
  validates_uniqueness_of :pid, :scope => :collection_id
  
  belongs_to :collection
end
