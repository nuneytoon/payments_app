module Api
  module V1
    class PaymentsController < ApplicationController
      before_action :set_invoice

      def create
        processor = PaymentProcessor.new(invoice: @invoice, amount_cents: payment_params[:amount_cents])
        payment = processor.call
        render json: { invoice: @invoice.reload.as_json(include: :payments) }
      end

      private

      def set_invoice
        @invoice = Invoice.find(params[:invoice_id])
      end

      def payment_params
        params.require(:payment).permit(:amount_cents, :processed_at)
      end
    end
  end
end
