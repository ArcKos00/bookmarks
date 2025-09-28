CREATE OR REPLACE TRIGGER MPS.trg_event_process_status_uk

  BEFORE INSERT ON MPS.event_process_status

  FOR EACH ROW

BEGIN

  IF :new.id IS NULL THEN

    :new.id := MPS.seq_event_process_status.nextval;

  END IF;

  

END;

/