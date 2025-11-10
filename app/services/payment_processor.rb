class PaymentProcessor
  def initialize(invoice:, amount_cents:)
    @invoice = invoice
    @amount_cents = amount_cents
  end

  def call
    ActiveRecord::Base.transaction do
      payment = @invoice.payments.create!(amount_cents: @amount_cents, processed_at: Time.current)
      
      @invoice.recalculate_balance!

      payment
    end
  end
end
