class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :payments, dependent: :destroy

  validates :total_cents, presence: true, numericality: { greater_than: 0 }

  def recalculate_balance!
    paid_amount = payments.sum(:amount_cents)
    update!(balance_cents: total_cents - paid_amount)
    update!(status: balance_cents <= 0 ? "paid" : "pending")
  end
end
