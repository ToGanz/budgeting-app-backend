class Plan < ApplicationRecord
  validates :title, presence: true, uniqueness: true

  has_many :transactions, dependent: :destroy
  belongs_to :user
end
