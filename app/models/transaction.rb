class Transaction < ApplicationRecord
  before_save :set_spending
  validates :description, presence: true

  belongs_to :plan


  private

  def set_spending
    self[:spending] = amount < 0
  end
end
