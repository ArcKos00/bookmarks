CREATE OR REPLACE TRIGGER MPS.trg_tmp_result
  AFTER INSERT ON MPS.event_process_request
  FOR EACH ROW
DECLARE
  -- local variables here
BEGIN
  IF inserting THEN
    INSERT INTO MPS.tmp_evproc_result
      (eventprocessingrequestid, eventreferenceuid)
    VALUES
      (:new.id, :new.ev_ref_id);
  END IF;
END trg_tmp_result;
/