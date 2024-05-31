CREATE OR REPLACE FUNCTION GET_NB_WORKERS(FACTORY_ID NUMBER) RETURN NUMBER IS
  nb_workers NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO nb_workers
  FROM workers
  WHERE factory_id = FACTORY_ID AND end_date IS NULL;
  RETURN nb_workers;
END GET_NB_WORKERS;

CREATE OR REPLACE FUNCTION GET_NB_BIG_ROBOTS RETURN NUMBER IS
  nb_big_robots NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO nb_big_robots
  FROM robots
  WHERE num_pieces > 3;
  RETURN nb_big_robots;
END GET_NB_BIG_ROBOTS;

CREATE OR REPLACE FUNCTION GET_BEST_SUPPLIER RETURN VARCHAR2 IS
  best_supplier VARCHAR2(100);
BEGIN
  SELECT supplier_name
  INTO best_supplier
  FROM (SELECT supplier_name FROM BEST_SUPPLIERS ORDER BY total_quantity DESC)
  WHERE ROWNUM = 1;
  RETURN best_supplier;
END GET_BEST_SUPPLIER;

CREATE OR REPLACE FUNCTION GET_OLDEST_WORKER RETURN NUMBER IS
  oldest_worker_id NUMBER;
BEGIN
  SELECT worker_id
  INTO oldest_worker_id
  FROM workers
  ORDER BY start_date ASC
  WHERE ROWNUM = 1;
  RETURN oldest_worker_id;
END GET_OLDEST_WORKER;