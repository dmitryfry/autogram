class Login < ApplicationRecord
  validates_uniqueness_of :name
end
