-- models/monthly_sales_forecast.sql
WITH monthly_data AS (
  SELECT
    month,
    total_revenue,
    ROW_NUMBER() OVER (ORDER BY month) AS month_number
  FROM
    {{ ref('ga_sessions_monthly') }}
),

-- Calculate moving averages
moving_avgs AS (
  SELECT
    month,
    total_revenue,
    month_number,
    AVG(total_revenue) OVER (ORDER BY month ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING) AS moving_avg_3m
  FROM
    monthly_data
)

-- Create forecast
SELECT
  month,
  total_revenue AS actual_revenue,
  LEAD(moving_avg_3m, 1) OVER (ORDER BY month) AS forecast_revenue,
  moving_avg_3m,
  CASE
    WHEN LEAD(total_revenue, 1) OVER (ORDER BY month) IS NOT NULL 
    THEN ABS(LEAD(total_revenue, 1) OVER (ORDER BY month) - moving_avg_3m)/LEAD(total_revenue, 1) OVER (ORDER BY month)
    ELSE NULL
  END AS forecast_error_pct
FROM
  moving_avgs
ORDER BY
  month