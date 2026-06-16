SELECT 
  aerospace_sector,
  COUNT(aerospace_sector)
FROM organizations
GROUP BY aerospace_sector
