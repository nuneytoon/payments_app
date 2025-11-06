class Refund < ApplicationRecord
  belongs_to :payment

  validates :amount_cents, presence: true, numericality: { greater_than: 0 }
  validate :cannot_exceed_payment_total

  after_commit :update_invoice_balance

  private

  def cannot_exceed_payment_total
    return unless payment

    total_refunded_so_far = payment.refunds.sum(:amount_cents)
    total_refunded_so_far -= amount_cents_was.to_i if persisted?

    if total_refunded_so_far + amount_cents > payment.amount_cents
      errors.add(:amount_cents, "cannot exceed payment amount (#{payment.amount_cents})")
    end
  end

  def update_invoice_balance
    payment.invoice.recalculate_balance!
  end
end
