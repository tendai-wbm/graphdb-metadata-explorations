SELECT 
	program,
	COUNT(program) AS num_space_incidents_with_program
FROM space_incidents
GROUP BY program
HAVING COUNT(program) > 1
