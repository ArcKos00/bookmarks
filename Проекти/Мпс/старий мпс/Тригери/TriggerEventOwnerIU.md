```
CREATE OR REPLACE TRIGGER MPS.trg_event_owner_iu

  AFTER INSERT OR UPDATE ON MPS.event_owner

  REFERENCING NEW AS NEW OLD AS OLD

  FOR EACH ROW

  

BEGIN

  IF inserting THEN

    INSERT INTO MPS.log_event_owner

      (id_event_owner,

       src_name,

       src_description,

       is_active,

       create_user_id,

       date_created,

       update_user_id,

       date_updated,

       log_update_user_id,

       log_date_updated)

    VALUES

      (:new.id,

       :new.src_name,

       :new.src_description,

       :new.is_active,

       :new.create_user_id,

       :new.date_created,

       :new.update_user_id,

       :new.date_updated,

       userenv('CLIENT_INFO'),

       SYSDATE

       );

  ELSIF updating THEN

    IF :old.src_name <> :new.src_name OR

       :old.src_description <> :new.src_description OR

       :old.is_active <> :new.is_active OR

       :old.create_user_id <> :new.create_user_id OR

       :old.date_created <> :new.date_created OR

       :old.update_user_id <> :new.update_user_id OR

       :old.date_updated <> :new.date_updated THEN

      INSERT INTO MPS.log_event_owner

        (id_event_owner,

         src_name,

         src_description,

         is_active,

         create_user_id,

         date_created,

         update_user_id,

         date_updated,

         log_update_user_id,

         log_date_updated)

      VALUES

        (:old.id,

         :new.src_name,

         :new.src_description,

         :new.is_active,

         :new.create_user_id,

         :new.date_created,

         :new.update_user_id,

         :new.date_updated,

         userenv('CLIENT_INFO'),

         SYSDATE);

    END IF;

  END IF;

  

END trg_event_handler_iu;

/
```