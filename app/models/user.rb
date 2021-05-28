class User < ApplicationRecord
  has_secure_password
  
  validates :email, uniqueness: true 
  validates_format_of :email, with: /@/ 
  validates :name, presence: true
  validates :password_digest, presence: true
end
