class Category < ApplicationRecord
  validates :name, presence: true

  has_many :transactions, dependent: :destroy
  belongs_to :user
end
