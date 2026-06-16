SELECT
  type AS report_type,
  COUNT(type) AS num_reports_with_reporttype
FROM reports
GROUP BY type
HAVING COUNT(type) > 1;
