```
CREATE OR REPLACE TRIGGER MPS.trg_log_event_handler_uk

  BEFORE INSERT ON MPS.log_event_handler

  FOR EACH ROW

BEGIN

  IF :new.id IS NULL THEN

    :new.id := MPS.seq_log_event_handler.nextval;

  END IF;

  

END;

/
```