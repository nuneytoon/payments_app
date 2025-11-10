class RefundProcessor
  def initialize(payment:, amount_cents:, reason:)
    @payment = payment
    @amount_cents = amount_cents
    @reason = reason
  end

  def call
    ActiveRecord::Base.transaction do
      refund = @payment.refunds.create!(amount_cents: @amount_cents, reason: @reason)

      @payment.invoice.recalculate_balance!

      refund
    end
  end
end