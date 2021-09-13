class User < ApplicationRecord
  validates :username, presence: true, length: { minimum: 2 }, uniqueness: { case_sensitive: false }
  validates :email, presence: true,
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  has_secure_password
end
