CREATE OR REPLACE TRIGGER MPS.trg_event_process_request_iu
  AFTER INSERT OR UPDATE ON MPS.event_process_request
  REFERENCING NEW AS NEW OLD AS OLD
  FOR EACH ROW

BEGIN
  IF inserting THEN
    INSERT INTO MPS.log_event_process_request
    
      (ev_procreq_id,
       ev_ref_id,
       ev_proc_id,
       ev_proc_req_status_id,
       date_created,
       date_updated,
       ERROR_CODE,
       error_descriptor,
       snd_temp_vers,
       snd_mess_body,
       date_sended,
       date_snd_lastsync,
       external_id,
       log_update_user_id,
       log_date_updated
       
       )
    
    VALUES
      (:new.id,
       :new.ev_ref_id,
       :new.ev_proc_id,
       :new.ev_proc_req_status_id,
       :new.date_created,
       :new.date_updated,
       :new.error_code,
       :new.error_descriptor,
       :new.snd_temp_vers,
       :new.snd_mess_body,
       :new.date_sended,
       :new.date_snd_lastsync,
       :new.external_id,
       
       userenv('CLIENT_INFO'),
       SYSDATE);
  
  ELSIF updating THEN
  
    IF
    
     (:new.ev_ref_id <> :old.ev_ref_id OR
     (:new.ev_ref_id IS NULL AND :old.ev_ref_id IS NOT NULL) OR
     (:new.ev_ref_id IS NOT NULL AND :old.ev_ref_id IS NULL)) OR
    
     (:new.ev_proc_id <> :old.ev_proc_id OR
     (:new.ev_proc_id IS NULL AND :old.ev_proc_id IS NOT NULL) OR
     (:new.ev_proc_id IS NOT NULL AND :old.ev_proc_id IS NULL)) OR
    
     (:new.ev_proc_req_status_id <> :old.ev_proc_req_status_id OR
     (:new.ev_proc_req_status_id IS NULL AND
     :old.ev_proc_req_status_id IS NOT NULL) OR
     (:new.ev_proc_req_status_id IS NOT NULL AND
     :old.ev_proc_req_status_id IS NULL)) OR
    
     (:new.date_created <> :old.date_created OR
     (:new.date_created IS NULL AND :old.date_created IS NOT NULL) OR
     (:new.date_created IS NOT NULL AND :old.date_created IS NULL)) OR
    
     (:new.error_code <> :old.error_code OR
     (:new.error_code IS NULL AND :old.error_code IS NOT NULL) OR
     (:new.error_code IS NOT NULL AND :old.error_code IS NULL)) OR
    
     (:new.date_updated <> :old.date_updated OR
     (:new.date_updated IS NULL AND :old.date_updated IS NOT NULL) OR
     (:new.date_updated IS NOT NULL AND :old.date_updated IS NULL)) OR
    
     (:new.error_code <> :old.error_code OR
     (:new.error_code IS NULL AND :old.error_code IS NOT NULL) OR
     (:new.error_code IS NOT NULL AND :old.error_code IS NULL)) OR
    
     (:new.error_descriptor <> :old.error_descriptor OR
     (:new.error_descriptor IS NULL AND :old.error_descriptor IS NOT NULL) OR
     (:new.error_descriptor IS NOT NULL AND :old.error_descriptor IS NULL)) OR
    
     (:new.snd_temp_vers <> :old.snd_temp_vers OR
     (:new.snd_temp_vers IS NULL AND :old.snd_temp_vers IS NOT NULL) OR
     (:new.snd_temp_vers IS NOT NULL AND :old.snd_temp_vers IS NULL)) OR
    
     (:new.snd_mess_body <> :old.snd_mess_body OR
     (:new.snd_mess_body IS NULL AND :old.snd_mess_body IS NOT NULL) OR
     (:new.snd_mess_body IS NOT NULL AND :old.snd_mess_body IS NULL)) OR
    
     (:new.date_sended <> :old.date_sended OR
     (:new.date_sended IS NULL AND :old.date_sended IS NOT NULL) OR
     (:new.date_sended IS NOT NULL AND :old.date_sended IS NULL)) OR
    
     (:new.date_snd_lastsync <> :old.date_snd_lastsync OR
     (:new.date_snd_lastsync IS NULL AND
     :old.date_snd_lastsync IS NOT NULL) OR
     (:new.date_snd_lastsync IS NOT NULL AND
     :old.date_snd_lastsync IS NULL)) OR
    
     (:new.external_id <> :old.external_id OR
     (:new.external_id IS NULL AND :old.external_id IS NOT NULL) OR
     (:new.external_id IS NOT NULL AND :old.external_id IS NULL))
    
     THEN
      INSERT INTO MPS.log_event_process_request
        (ev_procreq_id,
         ev_ref_id,
         ev_proc_id,
         ev_proc_req_status_id,
         date_created,
         date_updated,
         ERROR_CODE,
         error_descriptor,
         snd_temp_vers,
         snd_mess_body,
         date_sended,
         date_snd_lastsync,
         external_id,
         log_update_user_id,
         log_date_updated)
      VALUES
        (:old.id,
         :new.ev_ref_id,
         :new.ev_proc_id,
         :new.ev_proc_req_status_id,
         
         :new.date_created,
         :new.date_updated,
         :new.error_code,
         :new.error_descriptor,
         :new.snd_temp_vers,
         :new.snd_mess_body,
         :new.date_sended,
         :new.date_snd_lastsync,
         :new.external_id,
         
         userenv('CLIENT_INFO'),
         SYSDATE);
    END IF;
  END IF;

END trg_event_process_request_iu;
/
