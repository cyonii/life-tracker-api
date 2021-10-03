class UserSerializer < ActiveModel::Serializer
  attributes :email
  has_many :records
end
