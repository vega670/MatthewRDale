class Page < ActiveRecord::Base
  validates_uniqueness_of :permalink
end
