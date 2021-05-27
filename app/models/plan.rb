class Plan < ApplicationRecord
  validates :title, presence: true, uniqueness: true

  has_many :transactions
end
