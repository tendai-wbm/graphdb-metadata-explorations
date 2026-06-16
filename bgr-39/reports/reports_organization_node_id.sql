WITH report_org AS (
  SELECT  * FROM reports 
  WHERE organization_node_id IS NOT NULL
)

SELECT
  name AS organization_name, 
  COUNT(name)
FROM report_org repo
JOIN organizations org
ON repo.organization_node_id = org.node_id
GROUP BY name;
