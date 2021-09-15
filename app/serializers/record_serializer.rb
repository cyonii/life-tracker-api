class RecordSerializer < ActiveModel::Serializer
  attributes :id, :duration, :satisfaction, :date
  has_one :user
  has_one :activity
end
