class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :payments, dependent: :destroy

  validates :total_cents, presence: true, numericality: { greater_than: 0 }

  def get_total_refunded_cents
    Refund.joins(:payment)
          .where(payments: { invoice_id: id })
          .sum(:amount_cents)
  end

  def get_net_paid_cents
    payments.sum(:amount_cents) - get_total_refunded_cents
  end

  def recalculate_balance!
    update!(balance_cents: total_cents - get_net_paid_cents)
    update!(status: balance_cents <= 0 ? "paid" : "pending")
  end
end
