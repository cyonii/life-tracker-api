class RecordSerializer < ActiveModel::Serializer
  attributes :duration, :satisfaction, :date
  has_one :user
  has_one :activity
end
