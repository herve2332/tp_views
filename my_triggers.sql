CREATE OR REPLACE TRIGGER trg_insert_all_workers_elapsed
INSTEAD OF INSERT ON ALL_WORKERS_ELAPSED
FOR EACH ROW
BEGIN
  INSERT INTO workers (worker_id, lastname, firstname, age, start_date)
  VALUES (:NEW.worker_id, :NEW.lastname, :NEW.firstname, :NEW.age, :NEW.start_date);
EXCEPTION
  WHEN others THEN
    RAISE_APPLICATION_ERROR(-20001, 'Cannot perform DML operations on ALL_WORKERS_ELAPSED');
END;

CREATE OR REPLACE TRIGGER trg_add_robot_audit
AFTER INSERT ON robots
FOR EACH ROW
BEGIN
  INSERT INTO audit_robot (robot_id, audit_date)
  VALUES (:NEW.robot_id, SYSDATE);
END;

CREATE OR REPLACE TRIGGER trg_check_factories
BEFORE INSERT OR UPDATE OR DELETE ON robots_factories
FOR EACH ROW
DECLARE
  factory_count NUMBER;
  table_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO factory_count FROM factories;
  SELECT COUNT(*) INTO table_count FROM user_tables WHERE table_name LIKE 'WORKERS_FACTORY_%';
  IF factory_count != table_count THEN
    RAISE_APPLICATION_ERROR(-20002, 'Mismatch between number of factories and worker tables');
  END IF;
END;

CREATE OR REPLACE TRIGGER trg_calculate_duration
BEFORE UPDATE OF end_date ON workers
FOR EACH ROW
BEGIN
  IF :NEW.end_date IS NOT NULL THEN
    :NEW.duration := :NEW.end_date - :OLD.start_date;
  END IF;
END;
