CREATE OR REPLACE TRIGGER MPS.trg_log_event_type_uk
  BEFORE INSERT ON MPS.log_event_type
  FOR EACH ROW
BEGIN
  IF :new.id IS NULL THEN
    :new.id := MPS.seq_log_event_type.nextval;
  END IF;

END;
/
