CREATE OR REPLACE TRIGGER MPS.trg_event_upload_uk
  BEFORE INSERT ON MPS.event_upload
  FOR EACH ROW
BEGIN
  IF :new.id IS NULL THEN
    :new.id := MPS.seq_event_upload.nextval;
  END IF;

END;
/
