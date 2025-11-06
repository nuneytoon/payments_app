module Api
  module V1
    class PaymentsController < ApplicationController
      before_action :set_invoice

      def create
        payment = @invoice.payments.create!(payment_params)
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
