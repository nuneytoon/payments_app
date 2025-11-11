module Api
  module V1
    module Reports
      class RevenueController < ApplicationController
        def index
          start_date = parse_date(params[:start_date]) || 12.months.ago
          end_date = parse_date(params[:end_date]) || Date.today

          report = RevenueService.new(start_date, end_date).call

          render json: report
        end

        private

        def parse_date(date_string)
          return nil if date_string.blank?
          Date.parse(date_string)
        rescue ArgumentError
          nil
        end
      end
    end
  end
end