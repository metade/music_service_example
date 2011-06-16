class User < ActiveRecord::Base
  validates_presence_of :username
  validates_uniqueness_of :username
  
  def to_param
    username
  end
end
