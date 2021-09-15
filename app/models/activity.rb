class Activity < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  has_many :records
end
