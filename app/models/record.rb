class Record < ApplicationRecord
  validates :duration, presence: true, numericality: { greater_than_or_equal_to: 0.1, less_than_or_equal_to: 1440 }
  validates :satisfaction, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
  validates :user, :activity, :date, presence: true
  validates_uniqueness_of :date,
                          scope: %i[user_id activity_id],
                          message: 'record for this activity on this date already exists'

  belongs_to :user
  belongs_to :activity

  default_scope { order(date: :desc) }
end
