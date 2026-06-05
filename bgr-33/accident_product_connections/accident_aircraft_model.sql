/* Table containing all records from the 
   accidents, aircraft, aircraft_models and aircraft_products tables */
CREATE TABLE accident_connections AS (
SELECT 
	acc.node_id AS accident_node_id,
	airmo.model,
	airmo.renamed_manufacturer,
	airpro.node_id AS aircraft_product_node_id
FROM accidents acc
FULL OUTER JOIN aircraft air
ON acc.node_id = air.accident_node_id
FULL OUTER JOIN aircraft_models airmo
ON air.aircraft_model_id = airmo.aircraft_model_id
FULL OUTER JOIN aircraft_products AS airpro
ON airmo.aircraft_model_id = airpro.aircraft_model_id
);

-- function to perform some manual
-- data backfilling in order to realise the connection
CREATE OR REPLACE FUNCTION update_max_specs()
RETURNS VOID
AS $$
DECLARE
  aircraft RECORD;

BEGIN
  FOR aircraft IN (
    SELECT *
    FROM 
    	(VALUES 
    	('737-8','737 Max 8','737 Family','Boeing'),
    	('737-9','737 Max 9','737 Family','Boeing'),
    	('737-7','737 Max 7','737 Family','Boeing'),
    	('737-10','737 Max 10','737 Family','Boeing'),
    	('Boeing 737 MAX 10','737 Max 10','737 Family','Boeing'),
    	('Boeing 737 MAX 8','737 Max 8','737 Family','Boeing'),
    	('Boeing 737 MAX 7','737 Max 7','737 Family','Boeing'),    
    	('Boeing 737 MAX 9','737 Max 9','737 Family','Boeing'))
    AS t(reported_model,model_to_insert,family_to_insert,manufacturer_to_insert))
  
  LOOP
  	UPDATE aircraft_models
  	SET cirium_model = aircraft.model_to_insert,
  	    cirium_family = aircraft.family_to_insert,
  	    cirium_manufacturer = aircraft.manufacturer_to_insert
  	WHERE model = aircraft.reported_model;
  END LOOP;

END;
$$ LANGUAGE plpgsql;

/* CTE to retrieve all accidents involving aircraft that 
   share the following properties with aircraft models
   1. cirium_family
   2. cirium_model
   3. cirium_manufacturer */
WITH cirium_max_8 AS (
SELECT 
	aircraft_model_id,
	model,
	cirium_model,
	cirium_family,
	cirium_manufacturer
FROM aircraft_models
WHERE cirium_model = '737 Max 8'
)

SELECT
  accident_node_id,
  node_id AS aircraft_product_node_id,
  cirium_model,
  cirium_family,
  cirium_manufacturer
FROM cirium_max_8 max_8
FULL OUTER JOIN aircraft_products airpro
ON max_8.aircraft_model_id = airpro.aircraft_model_id
FULL OUTER JOIN aircraft air
ON max_8.aircraft_model_id = air.aircraft_model_id
WHERE cirium_model IS NOT NULL;
