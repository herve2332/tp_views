
   
CREATE VIEW ALL_WORKERS AS
SELECT first_name, last_name, age, first_day AS start_date
FROM WORKERS_FACTORY_1
WHERE last_day IS NULL 
UNION ALL
SELECT first_name, last_name, NULL AS age, start_date
FROM WORKERS_FACTORY_2
WHERE end_date IS NULL 
ORDER BY start_date DESC;
--ELECT * FROM ALL_WORKERS;

CREATE VIEW ALL_WORKERS_ELAPSED AS
SELECT first_name, last_name, age, start_date,
ROUND((SYSDATE - start_date), 0) AS days_elapsed
FROM ALL_WORKERS;
--SELECT * FROM ALL_WORKERS_ELAPSED;

CREATE OR REPLACE VIEW BEST_SUPPLIERS AS
SELECT s.name, sum(quantity) AS delivered_pieces
FROM SUPPLIERS_BRING_TO_FACTORY_1 s1
JOIN SUPPLIERS s ON s1.supplier_id = s.supplier_id
WHERE s1.quantity &gt; 1000
GROUP BY s.name
ORDER BY delivered_pieces DESC;
--SELECT * FROM BEST_SUPPLIERS;


CREATE OR replace VIEW ROBOTS_FACTORIES AS
SELECT r.model, f.main_location AS factory_location
FROM ROBOTS_FROM_FACTORY rf
JOIN ROBOTS r ON rf.robot_id = r.id
JOIN FACTORIES f ON rf.factory_id = f.id;
--SELECT * FROM ROBOTS_FACTORIES;
