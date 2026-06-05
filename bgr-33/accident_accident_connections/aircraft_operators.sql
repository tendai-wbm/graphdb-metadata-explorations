/* Table containing all records from the 
   accidents, aircraft, and aircraft_operators tables */
CREATE VIEW accident_connections AS (
SELECT 
	node_id AS accident_node_id, 
	aircraft_id, 
	air.operator_id AS aircraft_operator_id,
	air_op.name AS operator_name
FROM accidents acc
FULL OUTER JOIN aircraft air
ON acc.node_id = air.accident_node_id
FULL OUTER JOIN aircraft_operators air_op
ON air.operator_id = air_op.operator_id
);

/* query to select the number of accidents involving
   an aircraft operated by a given aircraft operator*/
SELECT operator_name, COUNT(accident_node_id)
FROM accident_connections
WHERE aircraft_operator_id IS NOT NULL
GROUP BY operator_name
HAVING COUNT(accident_node_id) > 1
