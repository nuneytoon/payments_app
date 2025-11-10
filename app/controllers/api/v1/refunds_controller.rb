module Api
  module V1
    class RefundsController < ApplicationController
      before_action :set_payment

      def create
        processor = RefundProcessor.new(payment: @payment, amount_cents: refund_params[:amount_cents], reason: refund_params[:reason])
        refund = processor.call
        render json: { invoice: @payment.invoice.reload.as_json(include: { payments: :refunds }) }
      end

      private

      def set_payment
        @payment = Payment.find(params[:payment_id])
      end

      def refund_params
        params.require(:refund).permit(:amount_cents, :reason)
      end
    end
  end
end
