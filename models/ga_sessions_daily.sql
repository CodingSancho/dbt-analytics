-- models/ga_sessions_daily.sql
SELECT
  PARSE_DATE('%Y%m%d', date) AS session_date,
  COUNT(*) AS session_count,
  COUNT(DISTINCT fullVisitorId) AS unique_visitors,
  SUM(totals.pageviews) AS pageviews,
  SUM(totals.transactions) AS transactions,
  SUM(totals.transactionRevenue)/1000000 AS revenue
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE
  _TABLE_SUFFIX BETWEEN '20160801' AND '20170731'
GROUP BY
  session_date
ORDER BY
  session_date