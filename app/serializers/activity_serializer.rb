class ActivitySerializer < ActiveModel::Serializer
  attributes :name
  has_many :records
end
