```
CREATE OR REPLACE TRIGGER MPS.trg_event_handler_iu

  AFTER INSERT OR UPDATE ON MPS.event_handler

  REFERENCING NEW AS NEW OLD AS OLD

  FOR EACH ROW

  

BEGIN

  IF inserting THEN

    INSERT INTO MPS.log_event_handler

      (ev_hand_id,

       ev_name,

       ev_descriptor,

       ev_owner_id,

       ev_type_id,

       delivery_type_id,

       priority,

       cnt_maxretry,

       per_retry_sec,

       snd_start_time,

       snd_stop_time,

       snd_onweekends,

       expir_timesec,

       is_active,

       create_user_id,

       date_created,

       update_user_id,

       date_updated,

       log_update_user_id,

       log_date_updated,

       business_line,

       message_type,

       is_delivery_guaranteed)

    VALUES

      (:new.id,

       :new.ev_name,

       :new.ev_descriptor,

       :new.ev_owner_id,

       :new.ev_type_id,

       :new.delivery_type_id,

       :new.priority,

       :new.cnt_maxretry,

       :new.per_retry_sec,

       :new.snd_start_time,

       :new.snd_stop_time,

       :new.snd_onweekends,

       :new.expir_timesec,

       :new.is_active,

       :new.create_user_id,

       :new.date_created,

       :new.update_user_id,

       :new.date_updated,

       userenv('CLIENT_INFO'),

       SYSDATE,

       :new.business_line,

       :new.message_type,

       :new.is_delivery_guaranteed);

  ELSIF updating THEN

    IF (:new.ev_name <> :old.ev_name OR

       (:new.ev_name IS NULL AND :old.ev_name IS NOT NULL) OR

       (:new.ev_name IS NOT NULL AND :old.ev_name IS NULL)) OR

       (:new.ev_descriptor <> :old.ev_descriptor OR

       (:new.ev_descriptor IS NULL AND :old.ev_descriptor IS NOT NULL) OR

       (:new.ev_descriptor IS NOT NULL AND :old.ev_descriptor IS NULL)) OR

       (:new.ev_owner_id <> :old.ev_owner_id OR

       (:new.ev_owner_id IS NULL AND :old.ev_owner_id IS NOT NULL) OR

       (:new.ev_owner_id IS NOT NULL AND :old.ev_owner_id IS NULL)) OR

       (:new.ev_type_id <> :old.ev_type_id OR

       (:new.ev_type_id IS NULL AND :old.ev_type_id IS NOT NULL) OR

       (:new.ev_type_id IS NOT NULL AND :old.ev_type_id IS NULL)) OR

       (:new.delivery_type_id <> :old.delivery_type_id OR

       (:new.delivery_type_id IS NULL AND

       :old.delivery_type_id IS NOT NULL) OR

       (:new.delivery_type_id IS NOT NULL AND

       :old.delivery_type_id IS NULL)) OR

       (:new.priority <> :old.priority OR

       (:new.priority IS NULL AND :old.priority IS NOT NULL) OR

       (:new.priority IS NOT NULL AND :old.priority IS NULL)) OR

       (:new.cnt_maxretry <> :old.cnt_maxretry OR

       (:new.cnt_maxretry IS NULL AND :old.cnt_maxretry IS NOT NULL) OR

       (:new.cnt_maxretry IS NOT NULL AND :old.cnt_maxretry IS NULL)) OR

       (:new.per_retry_sec <> :old.per_retry_sec OR

       (:new.per_retry_sec IS NULL AND :old.per_retry_sec IS NOT NULL) OR

       (:new.per_retry_sec IS NOT NULL AND :old.per_retry_sec IS NULL)) OR

       (:new.snd_start_time <> :old.snd_start_time OR

       (:new.snd_start_time IS NULL AND :old.snd_start_time IS NOT NULL) OR

       (:new.snd_start_time IS NOT NULL AND :old.snd_start_time IS NULL)) OR

       (:new.snd_stop_time <> :old.snd_stop_time OR

       (:new.snd_stop_time IS NULL AND :old.snd_stop_time IS NOT NULL) OR

       (:new.snd_stop_time IS NOT NULL AND :old.snd_stop_time IS NULL)) OR

       (:new.snd_onweekends <> :old.snd_onweekends OR

       (:new.snd_onweekends IS NULL AND :old.snd_onweekends IS NOT NULL) OR

       (:new.snd_onweekends IS NOT NULL AND :old.snd_onweekends IS NULL)) OR

       (:new.expir_timesec <> :old.expir_timesec OR

       (:new.expir_timesec IS NULL AND :old.expir_timesec IS NOT NULL) OR

       (:new.expir_timesec IS NOT NULL AND :old.expir_timesec IS NULL)) OR

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

       (:new.date_updated IS NOT NULL AND :old.date_updated IS NULL)) OR

       (:new.business_line <> :old.business_line OR

       (:new.business_line IS NULL AND :old.business_line IS NOT NULL) OR

       (:new.business_line IS NOT NULL AND :old.business_line IS NULL)) OR

       (:new.message_type <> :old.message_type OR

       (:new.message_type IS NULL AND :old.message_type IS NOT NULL) OR

       (:new.message_type IS NOT NULL AND :old.message_type IS NULL)) OR

       (:new.is_delivery_guaranteed <> :old.is_delivery_guaranteed OR

       (:new.is_delivery_guaranteed IS NULL AND  :old.is_delivery_guaranteed IS NOT NULL) OR

       (:new.is_delivery_guaranteed IS NOT NULL AND :old.is_delivery_guaranteed IS NULL))

     THEN

      INSERT INTO MPS.log_event_handler

        (ev_hand_id,

         ev_name,

         ev_descriptor,

         ev_owner_id,

         ev_type_id,

         delivery_type_id,

         priority,

         cnt_maxretry,

         per_retry_sec,

         snd_start_time,

         snd_stop_time,

         snd_onweekends,

         expir_timesec,

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

         :new.ev_owner_id,

         :new.ev_type_id,

         :new.delivery_type_id,

         :new.priority,

         :new.cnt_maxretry,

         :new.per_retry_sec,

         :new.snd_start_time,

         :new.snd_stop_time,

         :new.snd_onweekends,

         :new.expir_timesec,

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