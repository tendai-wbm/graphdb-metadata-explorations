/* Table containing all records from the 
   accidents, aircraft, aircraft_models and aircraft_operators tables */
CREATE OR REPLACE VIEW accident_connections AS (
SELECT 
	node_id AS accident_node_id, 
	aircraft_id, 
	air.operator_id AS aircraft_operator_id,
	air_op.name AS operator_name,
	airmo.cirium_model AS aircraft_model,
	airmo.cirium_manufacturer AS aircraft_manufacturer
FROM accidents acc
FULL OUTER JOIN aircraft air
ON acc.node_id = air.accident_node_id
FULL OUTER JOIN aircraft_models airmo
ON air.aircraft_model_id = airmo.aircraft_model_id
FULL OUTER JOIN aircraft_operators air_op
ON air.operator_id = air_op.operator_id 
);

/* query to select the number of accidents involving
   a given aircraft model operated by a the same aircraft operator */
SELECT operator_name, COUNT(accident_node_id)
FROM accident_connections
WHERE aircraft_operator_id IS NOT NULL
AND operator_name LIKE 'Delta%'
AND aircraft_model LIKE 'DC-8%'
GROUP BY operator_name
HAVING COUNT(accident_node_id) > 1
