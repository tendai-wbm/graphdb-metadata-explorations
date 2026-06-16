SELECT
  system_cause,
  COUNT(system_cause) AS num_space_incidents_with_systemcause
FROM space_incidents
GROUP BY system_cause
HAVING COUNT(system_cause) > 1
