CREATE OR REPLACE TRIGGER MPS.trg_event_processing_upd
  AFTER UPDATE OF ev_proc_req_status_id ON MPS.event_process_request
  FOR EACH ROW
BEGIN
  MPS.pkg_sms_module.p_trg_event_processing_upd(p_newsts => :new.ev_proc_req_status_id,
                                                 p_oldsts => :old.ev_proc_req_status_id);

END;
/