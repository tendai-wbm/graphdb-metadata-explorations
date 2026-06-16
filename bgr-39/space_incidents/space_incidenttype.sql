SELECT
  incident_type,
  COUNT(incident_type) AS num_space_incidents_with_incidenttype
FROM space_incidents
GROUP BY incident_type
HAVING COUNT(incident_type) > 1
