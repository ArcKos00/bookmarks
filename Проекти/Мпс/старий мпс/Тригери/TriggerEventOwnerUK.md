CREATE OR REPLACE TRIGGER MPS.trg_event_owner_uk

  BEFORE INSERT ON MPS.event_owner

  FOR EACH ROW

BEGIN

  IF :new.id IS NULL THEN

    :new.id := MPS.seq_event_owner.nextval;

  END IF;

  

END;

/