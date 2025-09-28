```
CREATE OR REPLACE TRIGGER MPS.trg_event_type_iu

  AFTER INSERT OR UPDATE ON MPS.event_type

  REFERENCING NEW AS NEW OLD AS OLD

  FOR EACH ROW

  

BEGIN

  IF inserting THEN

    INSERT INTO MPS.log_event_type

      (ev_type_id,

       ev_name,

       ev_descriptor,

       is_active,

       create_user_id,

       date_created,

       update_user_id,

       date_updated,

       log_update_user_id,

       log_date_updated)

    VALUES

      (:new.id,

       :new.ev_name,

       :new.ev_descriptor,

       :new.is_active,

       :new.create_user_id,

       :new.date_created,

       :new.update_user_id,

       :new.date_updated,

       userenv('CLIENT_INFO'),

       SYSDATE

       );

  ELSIF updating THEN

    IF (:new.ev_name <> :old.ev_name OR

       (:new.ev_name IS NULL AND :old.ev_name IS NOT NULL) OR

       (:new.ev_name IS NOT NULL AND :old.ev_name IS NULL)) OR

       (:new.ev_descriptor <> :old.ev_descriptor OR

       (:new.ev_descriptor IS NULL AND :old.ev_descriptor IS NOT NULL) OR

       (:new.ev_descriptor IS NOT NULL AND :old.ev_descriptor IS NULL)) OR

       (:new.is_active <> :old.is_active OR

       (:new.is_active IS NULL AND :old.is_active IS NOT NULL) OR

       (:new.is_active IS NOT NULL AND :old.is_active IS NULL)) OR

       (:new.create_user_id <> :old.create_user_id OR

       (:new.create_user_id IS NULL AND :old.create_user_id IS NOT NULL) OR

       (:new.create_user_id IS NOT NULL AND :old.create_user_id IS NULL)) OR

       (:new.date_created <> :old.date_created OR

       (:new.date_created IS NULL AND :old.date_created IS NOT NULL) OR

       (:new.date_created IS NOT NULL AND :old.date_created IS NULL)) OR

       (:new.update_user_id <> :old.update_user_id OR

       (:new.update_user_id IS NULL AND :old.update_user_id IS NOT NULL) OR

       (:new.update_user_id IS NOT NULL AND :old.update_user_id IS NULL)) OR

       (:new.date_updated <> :old.date_updated OR

       (:new.date_updated IS NULL AND :old.date_updated IS NOT NULL) OR

       (:new.date_updated IS NOT NULL AND :old.date_updated IS NULL)) THEN

      INSERT INTO MPS.log_event_type

        (ev_type_id,

         ev_name,

         ev_descriptor,

         is_active,

         create_user_id,

         date_created,

         update_user_id,

         date_updated,

         log_update_user_id,

         log_date_updated)

      VALUES

        (:old.id,

         :new.ev_name,

         :new.ev_descriptor,

         :new.is_active,

         :new.create_user_id,

         :new.date_created,

         :new.update_user_id,

         :new.date_updated,

         userenv('CLIENT_INFO'),

         SYSDATE

         );

    END IF;

  END IF;

END trg_event_handler_iu;

/
```