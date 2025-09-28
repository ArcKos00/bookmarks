CREATE OR REPLACE TRIGGER MPS.trg_event_type_uk

  BEFORE INSERT ON MPS.event_type

  FOR EACH ROW

BEGIN

  IF :new.id IS NULL THEN

    :new.id := MPS.seq_event_type.nextval;

  END IF;

  

END;

/