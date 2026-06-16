SELECT
  location_,
  COUNT(location_)
FROM places
LEFT JOIN locations
ON places.location_id = locations.location_id
GROUP BY location_;
