CREATE OR REPLACE TRIGGER MPS.trg_event_upload_iu

  AFTER INSERT OR UPDATE ON MPS.event_upload

  REFERENCING NEW AS NEW OLD AS OLD

  FOR EACH ROW

  

BEGIN

  IF inserting THEN

    INSERT INTO MPS.log_event_upload

      (ev_uplod_id,

       ev_ref_id,

       ev_owner_id,

       ev_type_id,

       ev_external_id,

       client_phone,

       argumemnts_json,

       snd_system_id,

       status_id,

       date_created,

       date_updated,

       ERROR_CODE,

       error_descriptor,

       status_upload_id,

       clid,

       contrid,

       batchid,

       log_update_user_id,

       log_date_updated)

    VALUES

      (:new.id,

       :new.ev_ref_id,

       :new.ev_owner_id,

       :new.ev_type_id,

       :new.ev_external_id,

       :new.client_phone,

       :new.argumemnts_json,

       :new.snd_system_id,

       :new.status_id,

       :new.date_created,

       :new.date_updated,

       :new.error_code,

       :new.error_descriptor,

       :new.status_upload_id,

       :new.clid,

       :new.contrid,

       :new.batchid,

       userenv('CLIENT_INFO'),

       SYSDATE

       );

  ELSIF updating THEN

    IF (:new.ev_ref_id <> :old.ev_ref_id OR

       (:new.ev_ref_id IS NULL AND :old.ev_ref_id IS NOT NULL) OR

       (:new.ev_ref_id IS NOT NULL AND :old.ev_ref_id IS NULL)) OR

       (:new.ev_owner_id <> :old.ev_owner_id OR

       (:new.ev_owner_id IS NULL AND :old.ev_owner_id IS NOT NULL) OR

       (:new.ev_owner_id IS NOT NULL AND :old.ev_owner_id IS NULL)) OR

       (:new.ev_type_id <> :old.ev_type_id OR

       (:new.ev_type_id IS NULL AND :old.ev_type_id IS NOT NULL) OR

       (:new.ev_type_id IS NOT NULL AND :old.ev_type_id IS NULL)) OR

       (:new.ev_external_id <> :old.ev_external_id OR

       (:new.ev_external_id IS NULL AND :old.ev_external_id IS NOT NULL) OR

       (:new.ev_external_id IS NOT NULL AND :old.ev_external_id IS NULL))

       OR (:new.client_phone <> :old.client_phone OR

       (:new.client_phone IS NULL AND :old.client_phone IS NOT NULL) OR

       (:new.client_phone IS NOT NULL AND :old.client_phone IS NULL))

       OR

       (:new.argumemnts_json <> :old.argumemnts_json OR

       (:new.argumemnts_json IS NULL AND :old.argumemnts_json IS NOT NULL) OR

       (:new.argumemnts_json IS NOT NULL AND :old.argumemnts_json IS NULL))

       OR (:new.snd_system_id <> :old.snd_system_id OR

       (:new.snd_system_id IS NULL AND :old.snd_system_id IS NOT NULL) OR

       (:new.snd_system_id IS NOT NULL AND :old.snd_system_id IS NULL))

       OR (:new.status_id <> :old.status_id OR

       (:new.status_id IS NULL AND :old.status_id IS NOT NULL) OR

       (:new.status_id IS NOT NULL AND :old.status_id IS NULL))

       OR (:new.date_updated <> :old.date_updated OR

       (:new.date_updated IS NULL AND :old.date_updated IS NOT NULL) OR

       (:new.date_updated IS NOT NULL AND :old.date_updated IS NULL)) OR

       (:new.date_created <> :old.date_created OR

       (:new.date_created IS NULL AND :old.date_created IS NOT NULL) OR

       (:new.date_created IS NOT NULL AND :old.date_created IS NULL))

       OR (:new.error_code <> :old.error_code OR

       (:new.error_code IS NULL AND :old.error_code IS NOT NULL) OR

       (:new.error_code IS NOT NULL AND :old.error_code IS NULL))

       OR (:new.error_descriptor <> :old.error_descriptor OR

       (:new.error_descriptor IS NULL AND

       :old.error_descriptor IS NOT NULL) OR

       (:new.error_descriptor IS NOT NULL AND

       :old.error_descriptor IS NULL))

       OR (:new.status_upload_id <> :old.status_upload_id OR

       (:new.status_upload_id IS NULL AND

       :old.status_upload_id IS NOT NULL) OR

       (:new.status_upload_id IS NOT NULL AND

       :old.status_upload_id IS NULL))

       OR (:new.clid <> :old.clid OR

       (:new.clid IS NULL AND :old.clid IS NOT NULL) OR

       (:new.clid IS NOT NULL AND :old.clid IS NULL))

       OR (:new.contrid <> :old.contrid OR

       (:new.contrid IS NULL AND :old.contrid IS NOT NULL) OR

       (:new.contrid IS NOT NULL AND :old.contrid IS NULL)) OR

       (:new.batchid <> :old.batchid OR

       (:new.batchid IS NULL AND :old.batchid IS NOT NULL) OR

       (:new.batchid IS NOT NULL AND :old.batchid IS NULL))

     THEN

      INSERT INTO MPS.log_event_upload

        (ev_uplod_id,

         ev_ref_id,

         ev_owner_id,

         ev_type_id,

         ev_external_id,

         client_phone,

         argumemnts_json,

         snd_system_id,

         status_id,

         date_created,

         date_updated,

         ERROR_CODE,

         error_descriptor,

         status_upload_id,

         clid,

         contrid,

         batchid,

         log_update_user_id,

         log_date_updated)

      VALUES

        (:old.id,

         :new.ev_ref_id,

         :new.ev_owner_id,

         :new.ev_type_id,

         :new.ev_external_id,

         :new.client_phone,

         :new.argumemnts_json,

         :new.snd_system_id,

         :new.status_id,

         :new.date_created,

         :new.date_updated,

         :new.error_code,

         :new.error_descriptor,

         :new.status_upload_id,

         :new.clid,

         :new.contrid,

         :new.batchid,

         userenv('CLIENT_INFO'),

         SYSDATE);

    END IF;

  END IF;

  

END trg_event_handler_iu;

/