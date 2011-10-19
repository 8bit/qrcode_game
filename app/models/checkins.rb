class Checkins < ActiveRecord::Base
  belongs_to :user
  has_one :locations
end
