class Page < ActiveRecord::Base
  validates_uniqueness_of :permalink
  acts_as_dimensioned_gallery
end
