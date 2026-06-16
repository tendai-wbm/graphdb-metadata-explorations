SELECT
  phase,
  COUNT(phase) AS num_space_incidents_with_phase
FROM space_incidents
GROUP BY phase
HAVING COUNT(phase) > 1
