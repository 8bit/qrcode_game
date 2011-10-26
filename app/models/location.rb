class Location < ActiveRecord::Base
  has_many :checkins
  has_many :users, :through => :checkins
  
  def to_param #overridden
    self.hash_code
  end
end
