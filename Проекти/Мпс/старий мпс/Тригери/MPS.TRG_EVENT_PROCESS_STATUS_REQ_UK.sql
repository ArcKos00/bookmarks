CREATE OR REPLACE TRIGGER MPS.trg_event_process_status_req_uk
  BEFORE INSERT ON MPS.event_process_status_req
  FOR EACH ROW
BEGIN
  IF :new.id IS NULL THEN
    :new.id := MPS.seq_event_process_status_req.nextval;
  END IF;

END;
/