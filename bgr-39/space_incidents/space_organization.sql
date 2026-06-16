SELECT
  organization,
  COUNT(organization) AS num_space_incidents_with_organization
FROM space_incidents
GROUP BY organization
HAVING COUNT(organization) > 1
