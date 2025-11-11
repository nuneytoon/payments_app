class RevenueService
  def initialize(start_date, end_date)
    @start_date = start_date.to_date.beginning_of_month
    @end_date = end_date.to_date.end_of_month
  end

  def call
    payments_by_month = Payment
      .where(created_at: @start_date..@end_date)
      .group("DATE_TRUNC('month', created_at)")
      .sum(:amount_cents)
      .transform_keys { |date| date.strftime("%Y-%m") }

    refunds_by_month = Refund
      .where(created_at: @start_date..@end_date)
      .group("DATE_TRUNC('month', created_at)")
      .sum(:amount_cents)
      .transform_keys { |date| date.strftime("%Y-%m") }

    build_monthly_report(payments_by_month, refunds_by_month)
  end

  private

  def build_monthly_report(payments, refunds)
    monthly_breakdown = []
    current_month = @start_date

    # Iterate through each month in the date range
    while current_month <= @end_date
      month_key = current_month.strftime("%Y-%m")
      
      payments_amount = payments[month_key] || 0
      refunds_amount = refunds[month_key] || 0
      net_revenue = payments_amount - refunds_amount

      monthly_breakdown << {
        month: month_key,
        month_name: current_month.strftime("%B %Y"),
        payments_cents: payments_amount,
        payments_dollars: format_dollars(payments_amount),
        refunds_cents: refunds_amount,
        refunds_dollars: format_dollars(refunds_amount),
        net_revenue_cents: net_revenue,
        net_revenue_dollars: format_dollars(net_revenue)
      }

      current_month = current_month.next_month
    end

    # Build complete report with summary
    {
      metadata: {
        start_date: @start_date.to_s,
        end_date: @end_date.to_s,
        currency: "USD",
        generated_at: Time.current.iso8601
      },
      summary: calculate_summary(monthly_breakdown),
      monthly_breakdown: monthly_breakdown
    }
  end

  def calculate_summary(monthly_breakdown)
    total_payments = monthly_breakdown.sum { |m| m[:payments_cents] }
    total_refunds = monthly_breakdown.sum { |m| m[:refunds_cents] }
    total_net_revenue = total_payments - total_refunds

    {
      total_payments_cents: total_payments,
      total_payments_dollars: format_dollars(total_payments),
      total_refunds_cents: total_refunds,
      total_refunds_dollars: format_dollars(total_refunds),
      total_net_revenue_cents: total_net_revenue,
      total_net_revenue_dollars: format_dollars(total_net_revenue),
      months_included: monthly_breakdown.count
    }
  end

  def format_dollars(cents)
    format("%.2f", cents / 100.0)
  end
end