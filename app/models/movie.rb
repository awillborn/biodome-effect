class Movie < ActiveRecord::Base
  scope :biodome_positive, -> { where(biodome: true) }
end