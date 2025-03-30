-- models/ga_sessions_monthly.sql
SELECT
  DATE_TRUNC(session_date, MONTH) AS month,
  SUM(session_count) AS total_sessions,
  SUM(unique_visitors) AS total_unique_visitors,
  SUM(pageviews) AS total_pageviews,
  SUM(transactions) AS total_transactions,
  SUM(revenue) AS total_revenue
FROM
  {{ ref('ga_sessions_daily') }}
GROUP BY
  month
ORDER BY
  month