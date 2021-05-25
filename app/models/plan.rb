class Plan < ApplicationRecord
  validates :title, presence: true, uniqueness: true

end
