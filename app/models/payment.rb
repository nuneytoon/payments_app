class Payment < ApplicationRecord
  belongs_to :invoice

  validates :amount_cents, presence: true, numericality: { greater_than: 0 }

  after_commit :update_invoice_balance

  private

  def update_invoice_balance
    invoice.recalculate_balance!
  end
end
