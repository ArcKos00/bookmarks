CREATE OR REPLACE TRIGGER MPS.trg_event_process_request_uk

  BEFORE INSERT ON MPS.event_process_request

  FOR EACH ROW

BEGIN

  IF :new.id IS NULL THEN

    :new.id := MPS.seq_event_process_request.nextval;

  END IF;

  

END;

/