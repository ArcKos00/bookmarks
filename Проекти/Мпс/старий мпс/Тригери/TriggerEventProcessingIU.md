```
CREATE OR REPLACE TRIGGER MPS.trg_event_processing_iu

  AFTER INSERT OR UPDATE ON MPS.event_processing

  REFERENCING NEW AS NEW OLD AS OLD

  FOR EACH ROW

  

BEGIN

  IF inserting THEN

    INSERT INTO MPS.log_event_processing

      (ev_proc_id,

       ev_ref_id,

       ev_upl_id,

       ev_hand_id,

       ev_proc_status_id,

       cnt_try,

       date_created,

       date_updated,

       ERROR_CODE,

       error_descriptor,

       last_proces_date,

       log_update_user_id,

       log_date_updated)

    VALUES

      (:new.id,

       :new.ev_ref_id,

       :new.ev_upl_id,

       :new.ev_hand_id,

       :new.ev_proc_status_id,

       :new.cnt_try,

       :new.date_created,

       :new.date_updated,

       :new.error_code,

       :new.error_descriptor,

       :new.last_proces_date,

       userenv('CLIENT_INFO'),

       SYSDATE);

  ELSIF updating THEN

    IF

     (:new.ev_ref_id <> :old.ev_ref_id OR

     (:new.ev_ref_id IS NULL AND :old.ev_ref_id IS NOT NULL) OR

     (:new.ev_ref_id IS NOT NULL AND :old.ev_ref_id IS NULL)) OR

     (:new.ev_upl_id <> :old.ev_upl_id OR

     (:new.ev_upl_id IS NULL AND :old.ev_upl_id IS NOT NULL) OR

     (:new.ev_upl_id IS NOT NULL AND :old.ev_upl_id IS NULL)) OR

     (:new.ev_hand_id <> :old.ev_hand_id OR

     (:new.ev_hand_id IS NULL AND :old.ev_hand_id IS NOT NULL) OR

     (:new.ev_hand_id IS NOT NULL AND :old.ev_hand_id IS NULL)) OR

     (:new.ev_proc_status_id <> :old.ev_proc_status_id OR

     (:new.ev_proc_status_id IS NULL AND

     :old.ev_proc_status_id IS NOT NULL) OR

     (:new.ev_proc_status_id IS NOT NULL AND

     :old.ev_proc_status_id IS NULL)) OR

     (:new.cnt_try <> :old.cnt_try OR

     (:new.cnt_try IS NULL AND :old.cnt_try IS NOT NULL) OR

     (:new.cnt_try IS NOT NULL AND :old.cnt_try IS NULL)) OR

     (:new.date_created <> :old.date_created OR

     (:new.date_created IS NULL AND :old.date_created IS NOT NULL) OR

     (:new.date_created IS NOT NULL AND :old.date_created IS NULL)) OR

     (:new.date_updated <> :old.date_updated OR

     (:new.date_updated IS NULL AND :old.date_updated IS NOT NULL) OR

     (:new.date_updated IS NOT NULL AND :old.date_updated IS NULL)) OR

     (:new.error_code <> :old.error_code OR

     (:new.error_code IS NULL AND :old.error_code IS NOT NULL) OR

     (:new.error_code IS NOT NULL AND :old.error_code IS NULL)) OR

     (:new.error_descriptor <> :old.error_descriptor OR

     (:new.error_descriptor IS NULL AND :old.error_descriptor IS NOT NULL) OR

     (:new.error_descriptor IS NOT NULL AND :old.error_descriptor IS NULL)) OR

     (:new.last_proces_date <> :old.last_proces_date OR

     (:new.last_proces_date IS NULL AND :old.last_proces_date IS NOT NULL) OR

     (:new.last_proces_date IS NOT NULL AND :old.last_proces_date IS NULL)) THEN

      INSERT INTO MPS.log_event_processing

        (ev_proc_id,

         ev_ref_id,

         ev_upl_id,

         ev_hand_id,

         ev_proc_status_id,

         cnt_try,

         date_created,

         date_updated,

         ERROR_CODE,

         error_descriptor,

         last_proces_date,

         log_update_user_id,

         log_date_updated)

      VALUES

        (:old.id,

         :new.ev_ref_id,

         :new.ev_upl_id,

         :new.ev_hand_id,

         :new.ev_proc_status_id,

         :new.cnt_try,

         :new.date_created,

         :new.date_updated,

         :new.error_code,

         :new.error_descriptor,

         :new.last_proces_date,

         userenv('CLIENT_INFO'),

         SYSDATE);

    END IF;

  END IF;

  

END trg_event_processing_iu;

/
```