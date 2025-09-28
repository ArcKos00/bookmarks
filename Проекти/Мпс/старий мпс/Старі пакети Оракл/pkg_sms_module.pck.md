```
CREATE OR REPLACE PACKAGE MPS.pkg_sms_module IS
  c_module CONSTANT VARCHAR2(100) := upper('pkg_sms_module');

  -- Author  : LUKIANENKOVO
  -- Created : 19.08.2021 10:52:57
  -- Purpose : sms module, переводим процедуры с transaction-sql => pl/sql
  -- FS 19772/19773  по ODI
  --  порядок запуска процедур внешними процессами этого модуля  7

  /*1.EventUploadToProcessing
  2.EventProcessingBatchGet
  3.p_evproc_req_status_update
  4.p_ev_proc_check_send_poss
  5.EventProcessingShortGetById
  6.p_evproc_req_status_update
  7.p_evproc_req_exter_update
  8.p_ep_external_batchget
  9.p_evproc_req_status_update
  10EventProcessingExpirationStatusSet*/

  TYPE curvar_type IS REF CURSOR RETURN MPS.event_handler%ROWTYPE;
  --для возврата ошибок
  TYPE t_obj_error IS TABLE OF MPS.sms_log_errors%ROWTYPE;
  t_tab t_obj_error;
  FUNCTION get_ttab RETURN t_obj_error
    PIPELINED;
  --для возврата ошибок процедурі p_ev_proc_check_send_poss
  TYPE t_obj_err_poss IS TABLE OF MPS.sms_err_poss%ROWTYPE;
  t_tab_poss t_obj_err_poss;
  FUNCTION get_poss RETURN t_obj_err_poss
    PIPELINED;

  TYPE t_msg_tml IS TABLE OF MPS.message_template%ROWTYPE;
  t_msg_t t_msg_tml;

  FUNCTION get_msg_tml RETURN t_msg_tml
    PIPELINED;
  PROCEDURE messagetemplatesgetbyhandlerid(p_ev_hnd_id IN NUMBER,
                                           resdata     OUT SYS_REFCURSOR);

  TYPE t_msg_act IS TABLE OF MPS.message_template%ROWTYPE;
  t_msg t_msg_act;

  FUNCTION get_msg RETURN t_msg_act
    PIPELINED;
  PROCEDURE messagetemplatesgetactive(resdata OUT SYS_REFCURSOR);

  TYPE t_ep_external_batcheget IS TABLE OF MPS.tmp_external_result %ROWTYPE;
  t_data t_ep_external_batcheget;

  FUNCTION get_data RETURN t_ep_external_batcheget
    PIPELINED;

  -- for procedure eventuploadtoprocessing 
  TYPE t_data_dequeued IS TABLE OF MPS.tmp_evproc_dequeued%ROWTYPE;
  t_dequeued t_data_dequeued;

  -- for procedure eventprocessingbatchget 
  TYPE t_data_result IS TABLE OF MPS.tmp_evproc_result%ROWTYPE;
  t_result t_data_result;

  FUNCTION get_dequeued RETURN t_data_dequeued
    PIPELINED;
  -- 15/02/2022 for davydov/procedure eventprocessingbatchget 
  TYPE t_data_proc_req IS TABLE OF MPS.event_processing%ROWTYPE;
  t_dpr t_data_proc_req;

  FUNCTION get_proc_req RETURN t_data_proc_req
    PIPELINED;

  FUNCTION get_result RETURN t_data_result
    PIPELINED;
  -- 15/02/2022 for davydov/procedure EventHandlerGetById

  TYPE t_ev_hand IS TABLE OF MPS.event_handler%ROWTYPE;
  t_evh t_ev_hand;

  FUNCTION get_ev RETURN t_ev_hand
    PIPELINED;

  -- 15/02/2022 for davydov/procedure  EventOwnersGet  MPS.EventOwner
  TYPE t_ev_own IS TABLE OF MPS.event_owner%ROWTYPE;
  t_own t_ev_own;

  FUNCTION get_own RETURN t_ev_own
    PIPELINED;

  -- 15/02/2022 for davydov/procedure  EventOwnersGet  EventOwnerToEventType EV_OWNER_EV_TYPE 
  TYPE t_ev_own_tp IS TABLE OF MPS.ev_owner_ev_type%ROWTYPE;
  t_own_tp t_ev_own_tp;

  FUNCTION get_own_tp RETURN t_ev_own_tp
    PIPELINED;

  -- 15/02/2022 for davydov/procedure  EventOwnersGet  EventTypesGet Event_Type 
  TYPE t_ev_tp IS TABLE OF MPS.event_type%ROWTYPE;
  t_evt t_ev_tp;

  FUNCTION get_ev_tp RETURN t_ev_tp
    PIPELINED;

  TYPE t_event_type_act IS RECORD(
    
    ev_name        VARCHAR2(100),
    ev_descriptor  VARCHAR2(1000),
    is_active      NUMBER,
    create_user_id VARCHAR2(32),
    date_created   DATE,
    update_user_id VARCHAR2(3),
    date_updated   DATE);

  TYPE t_event_type_act_f IS TABLE OF t_event_type_act;

  /*  TYPE t_message_template_act IS RECORD(
    id             NUMBER,
    mess_temp_id   VARCHAR2(32),
    mess_temp_body VARCHAR2(4000));
  
  TYPE t_message_template_act_f IS TABLE OF t_message_template_act;*/

  TYPE t_message_template IS RECORD(
    ev_handler_id  NUMBER,
    mess_temp_id   VARCHAR2(32),
    mess_temp_body VARCHAR2(4000),
    is_active      NUMBER,
    create_user_id VARCHAR2(32),
    date_created   DATE,
    update_user_id VARCHAR2(32),
    date_updated   DATE);

  TYPE t_message_template_f IS TABLE OF t_message_template;

  TYPE t_sender_system IS RECORD(
    snd_sysname       VARCHAR2(100),
    snd_sysdescriptor VARCHAR2(1000),
    is_active         NUMBER,
    create_user_id    VARCHAR2(32),
    date_created      DATE,
    update_user_id    VARCHAR2(32),
    date_updated      DATE);
  TYPE t_sender_system_f IS TABLE OF t_sender_system;

  TYPE t_delivery_type IS RECORD(
    key  NUMBER,
    NAME VARCHAR2(100));

  TYPE t_delivery_type_f IS TABLE OF t_delivery_type;

  TYPE t_ev_hand_ev_ownr_evtype IS RECORD(
    eventhandlerid NUMBER,
    NAME           VARCHAR2(100));

  TYPE t_ev_hand_ev_ownr_evtype_f IS TABLE OF t_ev_hand_ev_ownr_evtype;

  TYPE t_shortgetbyid IS RECORD(
    eventprocessingid        NUMBER,
    eventprocessingrequestid NUMBER,
    messagetemplateuid       VARCHAR2(100),
    clientphone              VARCHAR2(20),
    business_line            VARCHAR2(100),
    message_type             VARCHAR2(100),
    is_delivery_guaranteed   NUMBER, 
    deliverytype             NUMBER);

  TYPE t_shortgetbyid_f IS TABLE OF t_shortgetbyid;

  TYPE t_shortgetbyid_two IS RECORD(
    ev_code   VARCHAR2(100),
    ev_data   VARCHAR2(500),
    ev_upl_id NUMBER);

  TYPE t_shortgetbyid_two_f IS TABLE OF t_shortgetbyid_two;

  FUNCTION eventuploadstatusesget RETURN t_delivery_type_f
    PIPELINED
    PARALLEL_ENABLE;

  FUNCTION sendersystemsget RETURN t_sender_system_f
    PIPELINED
    PARALLEL_ENABLE;

  /* FUNCTION messagetemplatesgetbyhandlerid RETURN t_message_template_f
  PIPELINED
  PARALLEL_ENABLE;*/

  FUNCTION deliverytypesget RETURN t_delivery_type_f
    PIPELINED
    PARALLEL_ENABLE;

  FUNCTION eventprocessingstatusesget RETURN t_delivery_type_f
    PIPELINED
    PARALLEL_ENABLE;

  /*  FUNCTION messagetemplatesgetactive RETURN t_message_template_act_f
      PIPELINED
      PARALLEL_ENABLE;
  */
  FUNCTION f_evproc_shortgetbyid(eventprocessingrequestid IN NUMBER)
    RETURN t_shortgetbyid_f
    PIPELINED
    PARALLEL_ENABLE;

  FUNCTION f_evproc_shortgetbyid_two(eventprocessingrequestid IN NUMBER)
    RETURN t_shortgetbyid_two_f
    PIPELINED
    PARALLEL_ENABLE;

  PROCEDURE eventprocessingshortgetbyid(eventprocessingrequestid IN NUMBER,
                                        resdata                  OUT SYS_REFCURSOR,
                                        resdata_two              OUT SYS_REFCURSOR);

  FUNCTION f_eventhandler --EventHandlerGetByEventOwnerAndEvenType
  (eventownerid NUMBER, eventtypeid NUMBER) RETURN t_ev_hand_ev_ownr_evtype_f
    PIPELINED
    PARALLEL_ENABLE;

  PROCEDURE p_ev_hand_ev_owner_type(eventownerid NUMBER,
                                    eventtypeid  NUMBER,
                                    resdata      OUT SYS_REFCURSOR);

  PROCEDURE open_query(curvar_out OUT curvar_type);
  PROCEDURE eventhandleradd(NAME              VARCHAR2,
                            description       VARCHAR2,
                            eventownerid      NUMBER,
                            eventtypeid       NUMBER,
                            deliverytypeid    NUMBER,
                            priority          NUMBER,
                            createdby         VARCHAR2,
                            maxretrycount     NUMBER,
                            retryperiodsec    NUMBER,
                            sendtimestart     VARCHAR2,
                            sendtimestop      VARCHAR2,
                            sendingonweekends NUMBER,
                            expirationtimesec NUMBER,
                            resdata           OUT SYS_REFCURSOR);

  PROCEDURE eventownertoeventtypeadd(eventownerid NUMBER,
                                     eventtypeid  NUMBER,
                                     createdby    VARCHAR2);
  PROCEDURE p_ev_proc_check_send_poss(eventprocessingrequestid NUMBER,
                                      
                                      reserr OUT SYS_REFCURSOR);
  PROCEDURE eventhandlerupdate(eventhandlerid    NUMBER,
                               NAME              NUMBER,
                               description       NUMBER,
                               eventownerid      NUMBER,
                               eventtypeid       NUMBER,
                               deliverytypeid    NUMBER,
                               priority          NUMBER,
                               updatedby         NUMBER,
                               maxretrycount     NUMBER,
                               retryperiodsec    NUMBER,
                               sendtimestart     VARCHAR2,
                               sendtimestop      VARCHAR2,
                               sendingonweekends NUMBER,
                               expirationtimesec NUMBER,
                               isactive          NUMBER,
                               resdata           OUT SYS_REFCURSOR);
  PROCEDURE p_ep_external_batchget(processingcount      NUMBER,
                                   reprocessingdelaysec NUMBER,
                                   
                                   resdata OUT SYS_REFCURSOR);

  PROCEDURE sendersystemupdateactive(sendersystemid NUMBER,
                                     isactive       NUMBER,
                                     updatedby      VARCHAR2,
                                     resdata        OUT SYS_REFCURSOR);

  PROCEDURE eventprocessingbatchget(processingcount      NUMBER,
                                    reprocessingdelaysec NUMBER,
                                    resdata              OUT SYS_REFCURSOR,
                                    reserr               OUT SYS_REFCURSOR);
  PROCEDURE eventowneradd(NAME        VARCHAR2,
                          description VARCHAR2,
                          createdby   VARCHAR2,
                          resdata     OUT SYS_REFCURSOR);
  PROCEDURE eventownertoeventtypedelete(eventownerid NUMBER,
                                        eventtypeid  NUMBER);
  PROCEDURE eventownerupdate(eventownerid NUMBER,
                             NAME         VARCHAR2,
                             description  VARCHAR2,
                             updatedby    VARCHAR2,
                             resdata      OUT SYS_REFCURSOR);
  PROCEDURE eventownerupdateactive(eventownerid NUMBER,
                                   isactive     NUMBER,
                                   updatedby    VARCHAR2,
                                   resdata      OUT SYS_REFCURSOR);
  PROCEDURE eventprocessingexpirationstatusset;

  /* PROCEDURE p_evproc_req_exter_update(eventprocessingrequestid NUMBER,
  externalid               NVARCHAR2);*/
  PROCEDURE p_evproc_req_exter_update(eventprocessingrequestid NUMBER,
                                      eventstatus              NUMBER,
                                      sendedtemplateversion    VARCHAR2,
                                      sendedmessagebody        VARCHAR2,
                                      externalid               VARCHAR2);

  PROCEDURE p_evproc_req_status_update(eventprocessingrequestid NUMBER,
                                       eventstatus              NUMBER,
                                       errorcode                NUMBER,
                                       errordescription         VARCHAR2);
  PROCEDURE eventtypeadd(NAME         VARCHAR2,
                         description  VARCHAR2,
                         eventownerid NUMBER,
                         createdby    VARCHAR2,
                         resdata      OUT SYS_REFCURSOR);
  PROCEDURE eventtypeupdate(eventtypeid NUMBER,
                            NAME        VARCHAR2,
                            description VARCHAR2,
                            updatedby   VARCHAR2,
                            resdata     OUT SYS_REFCURSOR);

  PROCEDURE eventtypeupdateactive(eventtypeid NUMBER,
                                  isactive    NUMBER,
                                  updatedby   VARCHAR2,
                                  resdata     OUT SYS_REFCURSOR);
  PROCEDURE sendersystemupdate(sendersystemid NUMBER,
                               NAME           VARCHAR2,
                               description    VARCHAR2,
                               updatedby      VARCHAR2,
                               resdata        OUT SYS_REFCURSOR);

  PROCEDURE sendersystemadd(NAME        VARCHAR2,
                            description VARCHAR2,
                            createdby   VARCHAR2,
                            resdata     OUT SYS_REFCURSOR);
  PROCEDURE messagetemplateupdate(messagetemplateid   NUMBER,
                                  eventhandlerid      NUMBER,
                                  messagetemplatebody VARCHAR2,
                                  isactive            NUMBER,
                                  updatedby           VARCHAR2,
                                  resdata             OUT SYS_REFCURSOR);
  PROCEDURE messagetemplateadd(eventhandlerid      NUMBER,
                               messagetemplatebody VARCHAR2,
                               createdby           VARCHAR2,
                               resdata             OUT SYS_REFCURSOR);
  PROCEDURE eventuploadtoprocessing(processingcount NUMBER,
                                    p_cnt           OUT NUMBER,
                                    reserr          OUT SYS_REFCURSOR);
  PROCEDURE eventhandlergetbyid(eventhandlerid NUMBER,
                                resdata        OUT SYS_REFCURSOR);

  PROCEDURE eventhandlersget(resdata OUT SYS_REFCURSOR);

  PROCEDURE eventownersget(resdata1 OUT SYS_REFCURSOR,
                           resdata2 OUT SYS_REFCURSOR);

  PROCEDURE eventtypesget(resdata1 OUT SYS_REFCURSOR,
                          resdata2 OUT SYS_REFCURSOR);
  PROCEDURE p_trg_event_processing_upd(p_newsts IN NUMBER,
                                       p_oldsts IN NUMBER);
  PROCEDURE p_event_processing_upd(p_ev_proc_req_id NUMBER);
  PROCEDURE p_event_upload_upd(p_ev_proc_req_id NUMBER);
END pkg_sms_module;
/
CREATE OR REPLACE PACKAGE BODY MPS.pkg_sms_module IS

  PROCEDURE p_clear IS
  BEGIN
    DELETE FROM MPS.tmp_evproc_dequeued;
    DELETE FROM MPS.tmp_evproc_result;
    COMMIT;
  END;

  FUNCTION get_ttab RETURN t_obj_error
    PIPELINED AS
    i INTEGER;
  BEGIN
    i := t_tab.first;
    WHILE t_tab.exists(i)
    LOOP
      PIPE ROW(t_tab(i));
      i := t_tab.next(i);
    END LOOP;
    RETURN;
  END;

  FUNCTION get_poss RETURN t_obj_err_poss
    PIPELINED AS
    i INTEGER;
  BEGIN
    i := t_tab_poss.first;
    WHILE t_tab_poss.exists(i)
    LOOP
      PIPE ROW(t_tab_poss(i));
      i := t_tab_poss.next(i);
    END LOOP;
    RETURN;
  END;

  FUNCTION get_data RETURN t_ep_external_batcheget
    PIPELINED AS
    i INTEGER;
  BEGIN
    i := t_data.first;
    WHILE t_data.exists(i)
    LOOP
      PIPE ROW(t_data(i));
      i := t_data.next(i);
    END LOOP;
    RETURN;
  END;

  FUNCTION get_dequeued RETURN t_data_dequeued
    PIPELINED AS
    i INTEGER;
  BEGIN
    i := t_dequeued.first;
    WHILE t_dequeued.exists(i)
    LOOP
      PIPE ROW(t_dequeued(i));
      i := t_dequeued.next(i);
    END LOOP;
    RETURN;
  END;

  FUNCTION get_result RETURN t_data_result
    PIPELINED AS
    i INTEGER;
  BEGIN
    i := t_result.first;
    WHILE t_result.exists(i)
    LOOP
      PIPE ROW(t_result(i));
      i := t_result.next(i);
    END LOOP;
    RETURN;
  END;

  FUNCTION get_proc_req RETURN t_data_proc_req
    PIPELINED AS
    i INTEGER;
  BEGIN
    i := t_dpr.first;
    WHILE t_dpr.exists(i)
    LOOP
      PIPE ROW(t_dpr(i));
      i := t_dpr.next(i);
    END LOOP;
    RETURN;
  END;

  FUNCTION get_ev RETURN t_ev_hand
    PIPELINED AS
    i INTEGER;
  BEGIN
    i := t_evh.first;
    WHILE t_evh.exists(i)
    LOOP
      PIPE ROW(t_evh(i));
      i := t_evh.next(i);
    END LOOP;
    RETURN;
  END;

  PROCEDURE eventhandlergetbyid(eventhandlerid NUMBER,
                                resdata        OUT SYS_REFCURSOR) IS
  
  BEGIN
    -- курсор с данными 
    SELECT e.*
      BULK COLLECT
      INTO t_evh
      FROM MPS.event_handler e
     WHERE e.id = eventhandlerid;
  
    OPEN resdata FOR
      SELECT * FROM TABLE(MPS.pkg_sms_module.get_ev);
  
  END;

  PROCEDURE eventhandlersget(resdata OUT SYS_REFCURSOR) IS
  
  BEGIN
    -- курсор с данными 
    SELECT e.* BULK COLLECT INTO t_evh FROM MPS.event_handler e;
  
    OPEN resdata FOR
      SELECT * FROM TABLE(MPS.pkg_sms_module.get_ev);
  
  END;

  -- 15/02/2022 for davydov/procedure  EventOwnersGet  MPS.EventOwner

  FUNCTION get_own RETURN t_ev_own
    PIPELINED AS
    i INTEGER;
  BEGIN
    i := t_own.first;
    WHILE t_own.exists(i)
    LOOP
      PIPE ROW(t_own(i));
      i := t_own.next(i);
    END LOOP;
    RETURN;
  END;

  -- 15/02/2022 for davydov/procedure  EventOwnersGet  EventOwnerToEventType EV_OWNER_EV_TYPE 
  FUNCTION get_own_tp RETURN t_ev_own_tp
    PIPELINED AS
    i INTEGER;
  BEGIN
    i := t_own_tp.first;
    WHILE t_own_tp.exists(i)
    LOOP
      PIPE ROW(t_own_tp(i));
      i := t_own_tp.next(i);
    END LOOP;
    RETURN;
  END;

  PROCEDURE eventownersget(resdata1 OUT SYS_REFCURSOR,
                           resdata2 OUT SYS_REFCURSOR) IS
  
  BEGIN
    -- курсор с данными 
    SELECT e.* BULK COLLECT INTO t_own FROM MPS.event_owner e;
  
    OPEN resdata1 FOR
      SELECT * FROM TABLE(MPS.pkg_sms_module.t_own);
  
    SELECT e.* BULK COLLECT INTO t_own_tp FROM MPS.ev_owner_ev_type e;
  
    OPEN resdata2 FOR
      SELECT * FROM TABLE(MPS.pkg_sms_module.get_own_tp);
  
  END;

  -- 15/02/2022 for davydov/procedure  EventOwnersGet  EventTypesGet Event_Type 
  FUNCTION get_ev_tp RETURN t_ev_tp
    PIPELINED AS
    i INTEGER;
  BEGIN
    i := t_evt.first;
    WHILE t_evt.exists(i)
    LOOP
      PIPE ROW(t_evt(i));
      i := t_evt.next(i);
    END LOOP;
    RETURN;
  END;

  PROCEDURE eventtypesget(resdata1 OUT SYS_REFCURSOR,
                          resdata2 OUT SYS_REFCURSOR) IS
  
  BEGIN
    -- курсор с данными 
    SELECT e.* BULK COLLECT INTO t_evt FROM MPS.event_type e;
  
    OPEN resdata1 FOR
      SELECT * FROM TABLE(MPS.pkg_sms_module.get_ev_tp);
  
    SELECT e.* BULK COLLECT INTO t_own_tp FROM MPS.ev_owner_ev_type e;
  
    OPEN resdata2 FOR
      SELECT * FROM TABLE(MPS.pkg_sms_module.get_own_tp);
  
  END;

  FUNCTION f_evproc_shortgetbyid_two(eventprocessingrequestid IN NUMBER)
    RETURN t_shortgetbyid_two_f
    PIPELINED
    PARALLEL_ENABLE IS
    l_shortgetbyid_two_f t_shortgetbyid_two_f;
    CURSOR cur IS
      SELECT DISTINCT (ep.ev_code), ed.ev_data, ed.ev_upl_id
        FROM MPS.event_data            ed,
             MPS.event_parameters      ep,
             MPS.event_process_request epr,
             MPS.event_processing      eproc
       WHERE ed.ev_code = ep.id
         AND epr.ev_proc_id = eproc.id
         AND eproc.ev_upl_id = ed.ev_upl_id
         AND epr.id = eventprocessingrequestid;
  
  BEGIN
    OPEN cur;
    FETCH cur BULK COLLECT
      INTO l_shortgetbyid_two_f;
    CLOSE cur;
  
    FOR i IN 1 .. l_shortgetbyid_two_f.count
    LOOP
      PIPE ROW(l_shortgetbyid_two_f(i));
    END LOOP;
  
  END;

  FUNCTION --eventprocessingshortgetbyid(eventprocessingrequestid NUMBER)
    --  RETURN t_shortgetbyid_f
   f_evproc_shortgetbyid(eventprocessingrequestid IN NUMBER)
    RETURN t_shortgetbyid_f
    PIPELINED
    PARALLEL_ENABLE IS
    l_shortgetbyid_f t_shortgetbyid_f;
    CURSOR cur IS
      SELECT ep.id                     eventprocessingid,
             epr.id                    eventprocessingrequestid,
             mt.mess_temp_id           messagetemplateuid,
             eu.client_phone           clientphone,
             eh.business_line          businessline,
             eh.message_type           messagetype,
             eh.is_delivery_guaranteed isdeliveryguaranteed, 
             eh.delivery_type_id       deliverytype
        FROM MPS.event_process_request epr,
             MPS.event_processing      ep,
             MPS.message_template      mt,
             MPS.event_upload          eu,
             MPS.event_handler         eh
       WHERE eu.id = ep.ev_upl_id
         AND epr.ev_proc_id = ep.id
         AND mt.ev_handler_id = ep.ev_hand_id
         AND ep.ev_hand_id = eh.id
         AND mt.is_active = 1
         AND epr.id = eventprocessingrequestid;
  
  BEGIN
    OPEN cur;
    FETCH cur BULK COLLECT
      INTO l_shortgetbyid_f;
    CLOSE cur;
  
    FOR i IN 1 .. l_shortgetbyid_f.count
    LOOP
      PIPE ROW(l_shortgetbyid_f(i));
    END LOOP;
  
  END;

  PROCEDURE eventprocessingshortgetbyid(eventprocessingrequestid IN NUMBER,
                                        resdata                  OUT SYS_REFCURSOR,
                                        resdata_two              OUT SYS_REFCURSOR) IS
  BEGIN
    BEGIN
      OPEN resdata FOR
        SELECT *
          FROM TABLE(MPS.pkg_sms_module.f_evproc_shortgetbyid(eventprocessingrequestid));
      OPEN resdata_two FOR
        SELECT *
          FROM TABLE(MPS.pkg_sms_module.f_evproc_shortgetbyid_two(eventprocessingrequestid));
    EXCEPTION
      WHEN OTHERS THEN
        MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                          p_ermsg  => SQLERRM,
                                          p_module => c_module,
                                          p_proc   => upper('eventprocessingshortgetbyid'));
    END;
  
  END;

  FUNCTION get_msg RETURN t_msg_act
    PIPELINED AS
    i INTEGER;
  BEGIN
    i := t_msg.first;
    WHILE t_msg.exists(i)
    LOOP
      PIPE ROW(t_msg(i));
      i := t_msg.next(i);
    END LOOP;
    RETURN;
  END;

  PROCEDURE messagetemplatesgetactive(resdata OUT SYS_REFCURSOR) IS
  
  BEGIN
    BEGIN
      -- курсор с данными 
      SELECT e.*
        BULK COLLECT
        INTO t_msg
        FROM MPS.message_template e
       WHERE e.is_active = 1;
      OPEN resdata FOR
        SELECT id, mess_temp_id, mess_temp_body
          FROM TABLE(MPS.pkg_sms_module.get_msg);
    EXCEPTION
      WHEN OTHERS THEN
        MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                          p_ermsg  => SQLERRM,
                                          p_module => c_module,
                                          p_proc   => upper('messagetemplatesgetactive'));
      
    END;
  END;

  FUNCTION get_msg_tml RETURN t_msg_tml
    PIPELINED AS
    i INTEGER;
  BEGIN
    i := t_msg_t.first;
    WHILE t_msg_t.exists(i)
    LOOP
      PIPE ROW(t_msg_t(i));
      i := t_msg_t.next(i);
    END LOOP;
    RETURN;
  END;

  PROCEDURE messagetemplatesgetbyhandlerid(p_ev_hnd_id IN NUMBER,
                                           resdata     OUT SYS_REFCURSOR) IS
  
  BEGIN
    BEGIN
      -- курсор с данными 
      SELECT e.*
        BULK COLLECT
        INTO t_msg_t
        FROM MPS.message_template e
       WHERE e.ev_handler_id = p_ev_hnd_id;
      OPEN resdata FOR
        SELECT id, mess_temp_id, mess_temp_body
          FROM TABLE(MPS.pkg_sms_module.get_msg_tml);
    EXCEPTION
      WHEN OTHERS THEN
        MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                          p_ermsg  => SQLERRM,
                                          p_module => c_module,
                                          p_proc   => upper('messagetemplatesgetbyhandlerid'));
      
    END;
  END;

  FUNCTION sendersystemsget RETURN t_sender_system_f
    PIPELINED
    PARALLEL_ENABLE IS
    l_sender_system_f t_sender_system_f;
    CURSOR cur IS
      SELECT dt.snd_sysname,
             dt.snd_sysdescriptor,
             dt.is_active,
             dt.create_user_id,
             dt.date_created,
             dt.update_user_id,
             dt.date_updated
        FROM MPS.sender_system dt;
  
  BEGIN
    OPEN cur;
    FETCH cur BULK COLLECT
      INTO l_sender_system_f;
    CLOSE cur;
  
    FOR i IN 1 .. l_sender_system_f.count
    LOOP
      PIPE ROW(l_sender_system_f(i));
    END LOOP;
  
  EXCEPTION
    WHEN OTHERS THEN
      MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                        p_ermsg  => SQLERRM,
                                        p_module => c_module,
                                        p_proc   => upper('sendersystemsget'));
    
  END;

  FUNCTION eventuploadstatusesget RETURN t_delivery_type_f
    PIPELINED
    PARALLEL_ENABLE IS
    l_delivery_type_f t_delivery_type_f;
    CURSOR cur IS
      SELECT dt.id AS key, dt.eus_name AS VALUE
        FROM MPS.event_upload_status dt;
  
  BEGIN
    OPEN cur;
    FETCH cur BULK COLLECT
      INTO l_delivery_type_f;
    CLOSE cur;
  
    FOR i IN 1 .. l_delivery_type_f.count
    LOOP
      PIPE ROW(l_delivery_type_f(i));
    END LOOP;
  
  EXCEPTION
    WHEN OTHERS THEN
      MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                        p_ermsg  => SQLERRM,
                                        p_module => c_module,
                                        p_proc   => upper('EventUploadStatusesGet'));
    
  END;

  FUNCTION eventprocessingstatusesget RETURN t_delivery_type_f
    PIPELINED
    PARALLEL_ENABLE IS
    l_delivery_type_f t_delivery_type_f;
    CURSOR cur IS
      SELECT dt.id AS key, dt.eps_name AS VALUE
        FROM MPS.event_process_status dt;
  
  BEGIN
    OPEN cur;
    FETCH cur BULK COLLECT
      INTO l_delivery_type_f;
    CLOSE cur;
  
    FOR i IN 1 .. l_delivery_type_f.count
    LOOP
      PIPE ROW(l_delivery_type_f(i));
    END LOOP;
  
  EXCEPTION
    WHEN OTHERS THEN
      MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                        p_ermsg  => SQLERRM,
                                        p_module => c_module,
                                        p_proc   => upper('EventProcessingStatusesGet'));
    
  END;

  FUNCTION deliverytypesget RETURN t_delivery_type_f
    PIPELINED
    PARALLEL_ENABLE IS
    l_delivery_type_f t_delivery_type_f;
    CURSOR cur IS
      SELECT dt.id AS key, dt.dlt_name AS VALUE FROM MPS.delivery_type dt;
  
  BEGIN
    OPEN cur;
    FETCH cur BULK COLLECT
      INTO l_delivery_type_f;
    CLOSE cur;
  
    FOR i IN 1 .. l_delivery_type_f.count
    LOOP
      PIPE ROW(l_delivery_type_f(i));
    END LOOP;
  
  EXCEPTION
    WHEN OTHERS THEN
      MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                        p_ermsg  => SQLERRM,
                                        p_module => c_module,
                                        p_proc   => upper('deliverytypesget'));
    
  END;
  -- такое название невозможно оставлять, слтшком длинное,это для Архипенко Андрея 
  FUNCTION f_eventhandler
  --        getbyeventownerandeventype
  (eventownerid NUMBER, eventtypeid NUMBER)
  
   RETURN t_ev_hand_ev_ownr_evtype_f
    PIPELINED
    PARALLEL_ENABLE IS
    l_ev_hand_ev_ownr_evtype_f t_ev_hand_ev_ownr_evtype_f;
  
    CURSOR cur IS
      SELECT tt.id eventhandlerid, tt.ev_name NAME
        FROM MPS.event_handler tt
       WHERE tt.ev_owner_id = eventownerid
         AND tt.ev_type_id = eventtypeid;
  
  BEGIN
    OPEN cur;
    FETCH cur BULK COLLECT
      INTO l_ev_hand_ev_ownr_evtype_f;
    CLOSE cur;
  
    FOR i IN 1 .. l_ev_hand_ev_ownr_evtype_f.count
    LOOP
      PIPE ROW(l_ev_hand_ev_ownr_evtype_f(i));
    END LOOP;
  
  END;

  PROCEDURE p_ev_hand_ev_owner_type(eventownerid NUMBER,
                                    eventtypeid  NUMBER,
                                    resdata      OUT SYS_REFCURSOR) IS
  BEGIN
    BEGIN
      OPEN resdata FOR
        SELECT *
          FROM TABLE(MPS.pkg_sms_module.f_eventhandler(eventownerid,
                                                        eventtypeid));
    EXCEPTION
      WHEN OTHERS THEN
        MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                          p_ermsg  => SQLERRM,
                                          p_module => c_module,
                                          p_proc   => upper('EventHandlerGetByEventOwnerAndEvenType'));
    END;
  END;

  PROCEDURE eventhandleradd(NAME              VARCHAR2,
                            description       VARCHAR2,
                            eventownerid      NUMBER,
                            eventtypeid       NUMBER,
                            deliverytypeid    NUMBER,
                            priority          NUMBER,
                            createdby         VARCHAR2,
                            maxretrycount     NUMBER,
                            retryperiodsec    NUMBER,
                            sendtimestart     VARCHAR2,
                            sendtimestop      VARCHAR2,
                            sendingonweekends NUMBER,
                            expirationtimesec NUMBER,
                            resdata           OUT SYS_REFCURSOR) IS
  BEGIN
    BEGIN
      INSERT INTO MPS.event_handler
        (ev_name,
         ev_descriptor,
         ev_owner_id,
         ev_type_id,
         delivery_type_id,
         priority,
         create_user_id,
         date_created,
         cnt_maxretry,
         per_retry_sec,
         snd_start_time,
         snd_stop_time,
         snd_onweekends,
         expir_timesec,
         is_active)
      VALUES
        (NAME,
         description,
         eventownerid,
         eventtypeid,
         deliverytypeid,
         priority,
         createdby,
         SYSDATE,
         maxretrycount,
         retryperiodsec,
         sendtimestart,
         sendtimestop,
         sendingonweekends,
         expirationtimesec,
         1);
    EXCEPTION
      WHEN OTHERS THEN
        MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                          p_ermsg  => SQLERRM,
                                          p_module => c_module,
                                          p_proc   => upper('eventhandleradd'));
    END;
    SELECT e.* BULK COLLECT INTO t_tab FROM MPS.sms_log_errors e;
  
    OPEN resdata FOR
      SELECT * FROM TABLE(MPS.pkg_sms_module.get_ttab);
  
  END;

  /* Определение типа REF CURSOR. */
  --TYPE curvar_type IS REF CURSOR RETURN company%ROWTYPE;
  /* Тип указывается в списке параметров. */
  PROCEDURE open_query(curvar_out OUT curvar_type) IS
    local_cur curvar_type;
  BEGIN
    OPEN local_cur FOR
      SELECT * FROM MPS.event_handler;
    curvar_out := local_cur;
  END;

  PROCEDURE eventprocessingbatchget(processingcount NUMBER,
                                    /*reprocessingdelay*/
                                    reprocessingdelaysec NUMBER,
                                    resdata              OUT SYS_REFCURSOR,
                                    reserr               OUT SYS_REFCURSOR) IS
  
    l_datetimenow DATE := SYSDATE;
    l_co          PLS_INTEGER;
    ln_idsess     NUMBER;
    --l_err         PLS_INTEGER;
  
  BEGIN
    ln_idsess := userenv('sessionid');
    p_clear;
  
    FOR jj IN (
               --отбираем данные 
               SELECT t.eventprocessingid,
                       t.eventreferenceuid,
                       t.eventuploadid,
                       t.eventhandlerid,
                       t.statusid,
                       t.trycount,
                       t.eventprocessingrequestid,
                       t.requeststatusid
                 FROM (SELECT --top(@processingcount) --переменная  
                         ep.                  id eventprocessingid,
                         ep.ev_ref_id         eventreferenceuid,
                         ep.ev_upl_id         eventuploadid,
                         ep.ev_hand_id        eventhandlerid,
                         ep.ev_proc_status_id statusid,
                         ep.cnt_try           trycount,
                         --ep.date_updated              updateddatetime,
                         --ep.last_proces_date          lastprocessingdatetime,
                         epr.eventprocessingrequestid,
                         epr.statusid                 AS requeststatusid
                          FROM MPS.event_processing ep
                          LEFT JOIN (SELECT MAX(t.id) AS eventprocessingrequestid,
                                           t.ev_proc_id eventprocessingid,
                                           t.ev_proc_req_status_id statusid
                                      FROM MPS.event_process_request t
                                     GROUP BY t.ev_proc_id --EventProcessingId
                                             ,
                                              t.ev_proc_req_status_id) epr
                            ON ep.id = epr.eventprocessingid
                         WHERE (ep.ev_proc_status_id = 1 OR
                               (ep.ev_proc_status_id = 2 AND
                               epr.statusid IN (10, 20, 50, 80)))
                           AND (ep.last_proces_date IS NULL OR
                               (abs(ep.last_proces_date - l_datetimenow) * 24 * 60 * 60) >
                               reprocessingdelaysec) --reprocessingdelay -- переменная  
                        
                         ORDER BY nvl(ep.last_proces_date,
                                      to_date('01.01.1000', 'dd.mm.rrrr') /*l_datetimenow*/)) t
                WHERE rownum <= processingcount)
    LOOP
      --переменная на входе(top() mssql)
      BEGIN
        INSERT INTO MPS.tmp_evproc_dequeued
          (eventprocessingid,
           eventreferenceuid,
           eventuploadid,
           eventhandlerid,
           statusid,
           trycount,
           eventprocessingrequestid,
           requeststatusid)
        VALUES
          (jj.eventprocessingid,
           jj.eventreferenceuid,
           jj.eventuploadid,
           jj.eventhandlerid,
           jj.statusid,
           jj.trycount,
           jj.eventprocessingrequestid,
           jj.requeststatusid);
      EXCEPTION
        WHEN OTHERS THEN
          MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                            p_ermsg  => SQLERRM,
                                            p_module => c_module,
                                            p_proc   => upper('deliverytypesget'),
                                            p_idsess => ln_idsess);
      END;
    END LOOP;
  
    -- считаем количество вставленных записей во временную таблицу 
    BEGIN
      SELECT COUNT(1) INTO l_co FROM MPS.tmp_evproc_dequeued;
    EXCEPTION
      WHEN OTHERS THEN
        l_co := 0;
    END;
  
    --если что то вставилось  , обновлем даныые  таблицы MPS.event_processing 
    IF l_co <> 0 THEN
      --1
      BEGIN
        MERGE INTO MPS.event_processing ep
        
        USING (SELECT * FROM MPS.tmp_evproc_dequeued s) p
        ON (p.eventprocessingid = ep.id)
        WHEN MATCHED THEN
          UPDATE
             SET ep.date_updated     = l_datetimenow,
                 ep.last_proces_date = l_datetimenow;
      
      EXCEPTION
        WHEN OTHERS THEN
          MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                            p_ermsg  => SQLERRM,
                                            p_module => c_module,
                                            p_proc   => upper('deliverytypesget') ||
                                                        ' 1. MERGE INTO MPS.event_processing',
                                            p_idsess => ln_idsess);
          COMMIT;
      END;
    
      --2 обновляем данные временной таблицы , считываю даннеы из нее же + два источника event_upload/event_handler 
      BEGIN
      
        FOR i IN (SELECT eh.id, ted.eventprocessingid
                    FROM MPS.event_upload        eu,
                         MPS.tmp_evproc_dequeued ted,
                         MPS.event_handler       eh
                  
                   WHERE ted.eventuploadid = eu.id
                     AND eu.ev_owner_id = eh.ev_owner_id
                     AND eu.ev_type_id = eh.ev_type_id
                     AND eh.is_active = 1
                     AND ted.eventhandlerid IS NULL)
        
        LOOP
        
          UPDATE MPS.tmp_evproc_dequeued s
             SET s.eventhandlerid = i.id
           WHERE s.eventprocessingid = i.eventprocessingid;
        
        END LOOP;
      EXCEPTION
        WHEN OTHERS THEN
          MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                            p_ermsg  => SQLERRM,
                                            p_module => c_module,
                                            p_proc   => upper('deliverytypesget') ||
                                                        '  2.MERGE INTO MPS.tmp_evproc_dequeued',
                                            p_idsess => ln_idsess);
      END;
      -- COMMIT;
    
      --3  
      BEGIN
        MERGE INTO MPS.event_processing ep
        USING (SELECT ted.eventprocessingid
                 FROM MPS.tmp_evproc_dequeued ted
                 LEFT JOIN MPS.event_handler eh
                   ON ted.eventhandlerid = eh.id
                WHERE eh.is_active = 0) p
        ON (ep.id = p.eventprocessingid)
        WHEN MATCHED THEN
          UPDATE
             SET ep.ev_proc_status_id = 3,
                 ep.error_code        = '3010',
                 ep.error_descriptor  = 'Event hadler become inactive';
      EXCEPTION
        WHEN OTHERS THEN
          MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                            p_ermsg  => SQLERRM,
                                            p_module => c_module,
                                            p_proc   => upper('deliverytypesget') ||
                                                        '  3.MERGE INTO MPS.event_processing ',
                                            p_idsess => ln_idsess);
      END;
      -- COMMIT;
      --4
      BEGIN
        MERGE INTO MPS.event_processing ep
        USING (SELECT ted.eventprocessingid
                 FROM MPS.tmp_evproc_dequeued ted
                WHERE ted.eventhandlerid IS NULL) p
        ON (ep.id = p.eventprocessingid)
        WHEN MATCHED THEN
          UPDATE
             SET ep.ev_proc_status_id = 3,
                 ep.error_code        = '3010',
                 ep.error_descriptor  = 'Event hadler not found';
      
      EXCEPTION
        WHEN OTHERS THEN
          MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                            p_ermsg  => SQLERRM,
                                            p_module => c_module,
                                            p_proc   => upper('deliverytypesget ') ||
                                                        '  4.MERGE INTO MPS.tmp_evproc_dequeued',
                                            p_idsess => ln_idsess);
      END;
    
      -- COMMIT;
      --5
      BEGIN
        DELETE FROM MPS.tmp_evproc_dequeued deq
         WHERE deq.eventprocessingid IN
               (SELECT ep.id
                  FROM MPS.tmp_evproc_dequeued, MPS.event_processing ep
                 WHERE deq.eventprocessingid = ep.id
                   AND ep.ev_proc_status_id = 3);
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                            p_ermsg  => SQLERRM,
                                            p_module => c_module,
                                            p_proc   => upper('deliverytypesget') ||
                                                        '  5.DELETE FROM MPS.tmp_evproc_dequeued',
                                            p_idsess => ln_idsess);
      END;
      --  COMMIT;
      --6
      BEGIN
        INSERT INTO MPS.tmp_evproc_result
          SELECT epr.id, epr.ev_ref_id
            FROM MPS.event_process_request epr,
                 MPS.tmp_evproc_dequeued   deq,
                 MPS.event_upload          eu,
                 MPS.event_handler         eh
           WHERE epr. /*ev_proc_req_status_*/
           id = deq.eventprocessingrequestid
                
             AND deq.eventuploadid = eu.id
                
             AND deq.eventhandlerid = eh.id
             AND deq.requeststatusid IS NOT NULL
             AND deq.requeststatusid != 80
             AND deq.trycount <= eh.cnt_maxretry
                /*  comment 20/06/2022 AND ((eu.date_created - SYSDATE) * 24 * 60 * 60) <
                eh.expir_timesec*/
                
             AND ((SYSDATE - eu.date_created) * 24 * 60 * 60) <
                 eh.expir_timesec
             AND (((ceil(SYSDATE - trunc(SYSDATE, 'IW')) NOT IN (1, 7)) AND
                 eh.snd_onweekends = 0) OR eh.snd_onweekends = 1)
                
             AND ((to_date(trunc(SYSDATE) || ' ' || eh.snd_start_time,
                           'dd.mm.rrrr hh24:mi:ss') <
                 to_date(trunc(SYSDATE) || ' ' || eh.snd_stop_time,
                           'dd.mm.rrrr hh24:mi:ss')
                 
                 AND SYSDATE >
                 ((to_date(trunc(SYSDATE) || ' ' || eh.snd_start_time,
                                 'dd.mm.rrrr hh24:mi:ss'))) AND
                 SYSDATE <
                 ((to_date(trunc(SYSDATE) || ' ' || eh.snd_stop_time,
                             'dd.mm.rrrr hh24:mi:ss')))))
                
              OR ((to_date(trunc(SYSDATE) || ' ' || eh.snd_start_time,
                           'dd.mm.rrrr hh24:mi:ss') >
                 to_date(trunc(SYSDATE) || ' ' || eh.snd_stop_time,
                           'dd.mm.rrrr hh24:mi:ss')
                 
                 AND SYSDATE >
                 ((to_date(trunc(SYSDATE) || ' ' || eh.snd_start_time,
                                 'dd.mm.rrrr hh24:mi:ss')) + 1) AND
                 SYSDATE <
                 (((to_date(trunc(SYSDATE) || ' ' || eh.snd_stop_time,
                              'dd.mm.rrrr hh24:mi:ss')) + 1) + 1)));
      EXCEPTION
        WHEN OTHERS THEN
          MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                            p_ermsg  => SQLERRM,
                                            p_module => c_module,
                                            p_proc   => upper('deliverytypesget') ||
                                                        '  6.INSERT INTO MPS.tmp_evproc_result',
                                            p_idsess => ln_idsess);
      END;
    
      --COMMIT;
      --7
      BEGIN
        MERGE INTO MPS.event_process_request ep
        USING (SELECT ted.eventprocessingrequestid
                 FROM MPS.tmp_evproc_result ted) p
        ON (ep.id = p.eventprocessingrequestid)
        WHEN MATCHED THEN
          UPDATE SET ep.ev_proc_req_status_id = 1;
      
      EXCEPTION
        WHEN OTHERS THEN
          MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                            p_ermsg  => SQLERRM,
                                            p_module => c_module,
                                            p_proc   => upper('deliverytypesget') ||
                                                        '  7.MERGE INTO MPS.event_process_reques',
                                            p_idsess => ln_idsess);
      END;
    
      --  COMMIT;
      --8
      BEGIN
        INSERT /* ALL INTO MPS.tmp_evproc_result
                                                                                                                                                                                                                                                                                                                                                    (eventprocessingrequestid, eventreferenceuid)
                                                                                                                                                                                                                                                                                                                                                  VALUES
                                                                                                                                                                                                                                                                                                                                                    (id, ev_ref_id)*/
        INTO MPS.event_process_request
          (ev_ref_id, ev_proc_id) /*
                                                                                                                                                                                                                                                                                                                                                  VALUES
                                                                                                                                                                                                                                                                                                                                                    (ev_ref_id, ev_proc_id)*/
        
          SELECT deq.eventreferenceuid, deq.eventprocessingid
            FROM -- MPS.event_process_request epr,
                 MPS.tmp_evproc_dequeued deq,
                 MPS.event_upload        eu,
                 MPS.event_handler       eh
           WHERE /*epr.ev_proc_req_status_id = deq.eventprocessingrequestid
                                                                                                                                                                                                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                                                                                                                                                                                         AND*/
           deq.eventuploadid = eu.id
          
           AND deq.eventhandlerid = eh.id
           AND (deq.requeststatusid IS NULL /*IS NOT NULL*/
           OR deq.requeststatusid = 80)
           AND deq.trycount < eh.cnt_maxretry
          -- comment 20/06/2022 AND ((eu.date_created - SYSDATE) * 24 * 60 * 60) < eh.expir_timesec
           AND ((SYSDATE - eu.date_created) * 24 * 60 * 60) < eh.expir_timesec
          
           AND (((ceil(SYSDATE - trunc(SYSDATE, 'IW')) NOT IN (1, 7)) AND
           eh.snd_onweekends = 0) OR eh.snd_onweekends = 1)
          
           AND (to_date(trunc(SYSDATE) || ' ' || eh.snd_start_time,
                    'dd.mm.rrrr hh24:mi:ss') <
           to_date(trunc(SYSDATE) || ' ' || eh.snd_stop_time,
                    'dd.mm.rrrr hh24:mi:ss')
           
           AND
           SYSDATE > (to_date(trunc(SYSDATE) || ' ' || eh.snd_start_time,
                               'dd.mm.rrrr hh24:mi:ss')) AND
           SYSDATE < (to_date(trunc(SYSDATE) || ' ' || eh.snd_stop_time,
                               'dd.mm.rrrr hh24:mi:ss')))
          
           OR ((to_date(trunc(SYSDATE) || ' ' || eh.snd_start_time,
                     'dd.mm.rrrr hh24:mi:ss') >
           to_date(trunc(SYSDATE) || ' ' || eh.snd_stop_time,
                     'dd.mm.rrrr hh24:mi:ss')
           
           AND
           SYSDATE > (to_date(trunc(SYSDATE) || ' ' || eh.snd_start_time,
                                'dd.mm.rrrr hh24:mi:ss') + 1) AND
           SYSDATE <
           ((to_date(trunc(SYSDATE) || ' ' || eh.snd_stop_time,
                       'dd.mm.rrrr hh24:mi:ss') + 1) + 1)))
          
          ;
      EXCEPTION
        WHEN OTHERS THEN
          MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                            p_ermsg  => SQLERRM,
                                            p_module => c_module,
                                            p_proc   => upper('deliverytypesget') ||
                                                        '  8.INSERT ALL',
                                            p_idsess => ln_idsess);
      END;
    
      -- COMMIT;
      --9
      BEGIN
        MERGE INTO MPS.event_processing ep
        USING ( /*SELECT e.id
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           FROM MPS.event_processing e, MPS.tmp_evproc_result res
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          WHERE e.ev_ref_id = res.eventreferenceuid
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            AND e.ev_proc_status_id = 1*/
               SELECT e.id, deq.eventhandlerid
                 FROM MPS.event_processing    e,
                       MPS.tmp_evproc_result   res,
                       MPS.tmp_evproc_dequeued deq
                WHERE e.ev_ref_id = res.eventreferenceuid
                  AND e.ev_proc_status_id = 1
                  AND deq.eventreferenceuid = e.ev_ref_id) p
        ON (ep.id = p.id)
        WHEN MATCHED THEN
          UPDATE
             SET ep.ev_proc_status_id = 2, ep.ev_hand_id = p.eventhandlerid;
      EXCEPTION
        WHEN OTHERS THEN
          MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                            p_ermsg  => SQLERRM,
                                            p_module => c_module,
                                            p_proc   => upper('deliverytypesget') ||
                                                        '  9.MERGE INTO MPS.event_processing',
                                            p_idsess => ln_idsess);
      END;
      -- COMMIT;
      --10
      BEGIN
        MERGE INTO MPS.event_processing ep
        USING (SELECT deq.eventprocessingid
                 FROM MPS.event_processing    e,
                      MPS.tmp_evproc_dequeued deq,
                      MPS.tmp_evproc_result   res
                WHERE e.id = deq.eventprocessingid
                     
                  AND deq.eventreferenceuid = res.eventreferenceuid
                     /*                    AND deq.statusid IS NULL
                                         AND deq.statusid = 80
                     */
                  AND (deq.requeststatusid IS NULL OR
                      deq.requeststatusid = 80)
               
               ) p
        ON (ep.id = p.eventprocessingid)
        WHEN MATCHED THEN
          UPDATE SET ep.cnt_try = ep.cnt_try + 1;
      
      EXCEPTION
        WHEN OTHERS THEN
          MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                            p_ermsg  => SQLERRM,
                                            p_module => c_module,
                                            p_proc   => upper('deliverytypesget') ||
                                                        '  10.MERGE INTO MPS.event_processing',
                                            p_idsess => ln_idsess);
      END;
      -- COMMIT;
    END IF;
  
    COMMIT;
  
    SELECT e.* BULK COLLECT INTO t_result FROM MPS.tmp_evproc_result e;
    OPEN resdata FOR
      SELECT * FROM TABLE(MPS.pkg_sms_module.get_result);
  
    SELECT e.*
      BULK COLLECT
      INTO t_tab
      FROM MPS.sms_log_errors e
     WHERE e.id_sess = ln_idsess;
  
    OPEN reserr FOR
      SELECT * FROM TABLE(MPS.pkg_sms_module.get_ttab);
  
  END;

  PROCEDURE p_ev_proc_check_send_poss(eventprocessingrequestid NUMBER,
                                      reserr                   OUT SYS_REFCURSOR) --eventprocessingchecksendingpossibility 
   IS
    ln_co_event PLS_INTEGER;
  
  BEGIN
  
    DELETE FROM MPS.tmp_evproc_event;
    DELETE FROM MPS.sms_err_poss;
    COMMIT;
  
    BEGIN
      INSERT INTO MPS.tmp_evproc_event
        SELECT ep.id,
               epr. /*ev_proc_req_status_*/ id,
               ep.ev_proc_status_id,
               epr.ev_proc_req_status_id,
               ep.cnt_try,
               eh.cnt_maxretry,
               eu.date_created,
               eh.expir_timesec,
               eh.snd_onweekends,
               eh.snd_start_time,
               eh.snd_stop_time
          FROM MPS.event_processing      ep,
               MPS.event_process_request epr,
               MPS.event_handler         eh,
               MPS.event_upload          eu
         WHERE ep.id = epr.ev_proc_id
              
           AND ep.ev_hand_id = eh.id
              
           AND ep.ev_upl_id = eu.id
           AND epr. /*ev_proc_req_status_*/
         id = eventprocessingrequestid;
    EXCEPTION
      WHEN OTHERS THEN
        MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                          p_ermsg  => SQLERRM,
                                          p_module => c_module,
                                          p_proc   => upper('p_ev_proc_check_send_poss') ||
                                                      '  1.INSERT INTO MPS.tmp_evproc_event');
    END;
    COMMIT;
    --1
    BEGIN
      SELECT COUNT(1) INTO ln_co_event FROM MPS.tmp_evproc_event;
    EXCEPTION
      WHEN OTHERS THEN
        ln_co_event := 0;
      
    END;
  
    IF ln_co_event = 0 THEN
      INSERT INTO MPS.sms_err_poss VALUES (50001, 'Event not found ,1');
      -- raise_application_error(-20001, '50001, Event not found ,1');
      SELECT e.* BULK COLLECT INTO t_tab_poss FROM MPS.sms_err_poss e;
    
      OPEN reserr FOR
        SELECT * FROM TABLE(MPS.pkg_sms_module.get_poss);
    END IF;
    --2
    ln_co_event := 0;
    BEGIN
      SELECT COUNT(1)
        INTO ln_co_event
        FROM MPS.tmp_evproc_event
       WHERE eventprocessingrequeststatusid = 20
         AND eventprocessingstatusid = 2;
    EXCEPTION
      WHEN OTHERS THEN
        ln_co_event := 0;
      
    END;
  
    IF ln_co_event = 0 THEN
      -- raise_application_error(-20001, '50002, Event is wrong status  ,1');
      INSERT INTO MPS.sms_err_poss
      VALUES
        (50002, 'Event is wrong status  ,1');
    
      SELECT e.* BULK COLLECT INTO t_tab_poss FROM MPS.sms_err_poss e;
    
      OPEN reserr FOR
        SELECT * FROM TABLE(MPS.pkg_sms_module.get_poss);
    
    END IF;
    --3
    ln_co_event := 0;
    BEGIN
      SELECT COUNT(1)
        INTO ln_co_event
        FROM MPS.tmp_evproc_event
       WHERE trycount < maxretrycount;
    EXCEPTION
      WHEN OTHERS THEN
        ln_co_event := 0;
    END;
    IF ln_co_event = 0 THEN
      --  raise_application_error(-20001,
      --                         '50003, TryCount exceeded the limits ,1');
    
      INSERT INTO MPS.sms_err_poss
      VALUES
        (50003, 'TryCount exceeded the limits ,1');
    
      SELECT e.* BULK COLLECT INTO t_tab_poss FROM MPS.sms_err_poss e;
    
      OPEN reserr FOR
        SELECT * FROM TABLE(MPS.pkg_sms_module.get_poss);
    END IF;
  
    --4
  
    ln_co_event := 0;
    BEGIN
      SELECT COUNT(1)
        INTO ln_co_event
        FROM MPS.tmp_evproc_event tt
       WHERE ((SYSDATE - createddatetime) * 24 * 60 * 60) <
             expirationtimesec;
    
    EXCEPTION
      WHEN OTHERS THEN
        ln_co_event := 0;
    END;
    IF ln_co_event = 0 THEN
      -- raise_application_error(-20001, '50004, Event expired,1');
      INSERT INTO MPS.sms_err_poss VALUES (50004, 'Event expired,1');
    
      SELECT e.* BULK COLLECT INTO t_tab_poss FROM MPS.sms_err_poss e;
    
      OPEN reserr FOR
        SELECT * FROM TABLE(MPS.pkg_sms_module.get_poss);
    END IF;
    --5
    ln_co_event := 0;
    BEGIN
      SELECT COUNT(1)
        INTO ln_co_event
        FROM MPS.tmp_evproc_event tee
       WHERE ((ceil(SYSDATE - trunc(SYSDATE, 'IW')) NOT IN (1, 7)) AND
             tee.sendingonweekends = 0)
          OR tee.sendingonweekends = 1;
    EXCEPTION
      WHEN OTHERS THEN
        ln_co_event := 0;
    END;
  
    IF ln_co_event = 0 THEN
    
      INSERT INTO MPS.sms_err_poss
      VALUES
        (50005, 'Inappropriate day of the week to send,1');
    
      SELECT e.* BULK COLLECT INTO t_tab_poss FROM MPS.sms_err_poss e;
    
      OPEN reserr FOR
        SELECT * FROM TABLE(MPS.pkg_sms_module.get_poss);
    END IF;
  
    ln_co_event := 0;
    BEGIN
      SELECT COUNT(1)
        INTO ln_co_event
        FROM MPS.tmp_evproc_event tee
       WHERE ((to_date(trunc(SYSDATE) || ' ' || tee.sendtimestart,
                       'dd.mm.rrrr hh24:mi:ss') <
             to_date(trunc(SYSDATE) || ' ' || tee.sendtimestop,
                       'dd.mm.rrrr hh24:mi:ss')
             
             AND SYSDATE >
             ((to_date(trunc(SYSDATE) || ' ' || tee.sendtimestart,
                             'dd.mm.rrrr hh24:mi:ss'))) AND
             SYSDATE <
             ((to_date(trunc(SYSDATE) || ' ' || tee.sendtimestop,
                         'dd.mm.rrrr hh24:mi:ss')))))
            
          OR ((to_date(trunc(SYSDATE) || ' ' || tee.sendtimestart,
                       'dd.mm.rrrr hh24:mi:ss') >
             to_date(trunc(SYSDATE) || ' ' || tee.sendtimestop,
                       'dd.mm.rrrr hh24:mi:ss')
             
             AND SYSDATE >
             ((to_date(trunc(SYSDATE) || ' ' || tee.sendtimestart,
                             'dd.mm.rrrr hh24:mi:ss')) + 1) AND
             SYSDATE <
             (((to_date(trunc(SYSDATE) || ' ' || tee.sendtimestop,
                          'dd.mm.rrrr hh24:mi:ss')) + 1) + 1)));
    
      /* ((to_char(tee.sendtimestart, 'hh24:mi:ss') <
         to_char(tee.sendtimestop, 'hh24:mi:ss')
         
         AND SYSDATE > ((SYSDATE - tee.sendtimestart) + 1) AND
         SYSDATE < ((SYSDATE - tee.sendtimestop) + 1)))
        
      OR ((to_char(tee.sendtimestart, 'hh24:mi:ss') >
         to_char(tee.sendtimestop, 'hh24:mi:ss')
         
         AND SYSDATE > ((SYSDATE - tee.sendtimestart) + 1) AND
         SYSDATE < (((SYSDATE - tee.sendtimestop \*sendtimestart*\
         ) + 1) + 1)))*/
    EXCEPTION
      WHEN OTHERS THEN
        ln_co_event := 0;
    END;
  
    IF ln_co_event = 0 THEN
    
      INSERT INTO MPS.sms_err_poss
      VALUES
        (50006, 'Inappropriate time of the day to send,1');
    
      SELECT e.* BULK COLLECT INTO t_tab_poss FROM MPS.sms_err_poss e;
    
      OPEN reserr FOR
        SELECT * FROM TABLE(MPS.pkg_sms_module.get_poss);
    END IF;
  
  END;

  PROCEDURE eventhandlerupdate(eventhandlerid    NUMBER,
                               NAME              NUMBER,
                               description       NUMBER,
                               eventownerid      NUMBER,
                               eventtypeid       NUMBER,
                               deliverytypeid    NUMBER,
                               priority          NUMBER,
                               updatedby         NUMBER,
                               maxretrycount     NUMBER,
                               retryperiodsec    NUMBER,
                               sendtimestart     VARCHAR2,
                               sendtimestop      VARCHAR2,
                               sendingonweekends NUMBER,
                               expirationtimesec NUMBER,
                               isactive          NUMBER,
                               resdata           OUT SYS_REFCURSOR) IS
  
  BEGIN
    BEGIN
      UPDATE MPS.event_handler eha
         SET eha.ev_name          = NAME,
             eha.ev_descriptor    = description,
             eha.ev_owner_id      = eventownerid,
             eha.ev_type_id       = eventtypeid,
             eha.delivery_type_id = deliverytypeid,
             eha.priority         = priority,
             eha.update_user_id   = updatedby,
             eha.date_updated     = SYSDATE,
             eha.cnt_maxretry     = maxretrycount,
             eha.per_retry_sec    = retryperiodsec,
             eha.snd_start_time   = sendtimestart,
             eha.snd_stop_time    = sendtimestop,
             eha.snd_onweekends   = sendingonweekends,
             eha.expir_timesec    = expirationtimesec,
             eha.is_active        = isactive
       WHERE eha.id = eventhandlerid;
    
    EXCEPTION
      WHEN OTHERS THEN
        MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                          p_ermsg  => SQLERRM,
                                          p_module => c_module,
                                          p_proc   => upper('eventhandlerupdate'));
    END;
    COMMIT;
    SELECT e.* BULK COLLECT INTO t_tab FROM MPS.sms_log_errors e;
  
    OPEN resdata FOR
      SELECT * FROM TABLE(MPS.pkg_sms_module.get_ttab);
  END;

  PROCEDURE eventowneradd(NAME        VARCHAR2,
                          description VARCHAR2,
                          createdby   VARCHAR2,
                          resdata     OUT SYS_REFCURSOR) IS
  
  BEGIN
    BEGIN
      INSERT INTO MPS.event_owner
        (src_name,
         src_description,
         is_active,
         create_user_id,
         date_created)
      VALUES
        (NAME, description, 1, createdby, SYSDATE);
    EXCEPTION
      WHEN OTHERS THEN
        MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                          p_ermsg  => SQLERRM,
                                          p_module => c_module,
                                          p_proc   => upper('EventOwnerAdd'));
    END;
    SELECT e.* BULK COLLECT INTO t_tab FROM MPS.sms_log_errors e;
  
    OPEN resdata FOR
      SELECT * FROM TABLE(MPS.pkg_sms_module.get_ttab);
  END;

  PROCEDURE eventownertoeventtypeadd(eventownerid NUMBER,
                                     eventtypeid  NUMBER,
                                     createdby    VARCHAR2) IS
    ln_co PLS_INTEGER;
  BEGIN
    BEGIN
      SELECT COUNT(1)
        INTO ln_co
        FROM MPS.ev_owner_ev_type eoet
       WHERE eoet.ev_owner_id = eventownerid
         AND eoet.ev_type_id = eventtypeid;
    EXCEPTION
      WHEN OTHERS THEN
        ln_co := 0;
    END;
  
    IF ln_co = 0 THEN
      BEGIN
        INSERT INTO MPS.ev_owner_ev_type
          (ev_owner_id, ev_type_id, create_user_id, date_created)
        VALUES
          (eventownerid, eventtypeid, createdby, SYSDATE);
      
      EXCEPTION
        WHEN OTHERS THEN
          MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                            p_ermsg  => SQLERRM,
                                            p_module => c_module,
                                            p_proc   => upper('eventownertoeventtypeadd'));
      END;
      COMMIT;
    ELSE
      raise_application_error(-20001,
                              '50011, EventOwner to EventType connection can not be created. Such an entity already exist, 1');
    
    END IF;
  
  END;

  PROCEDURE eventownertoeventtypedelete(eventownerid NUMBER,
                                        eventtypeid  NUMBER) IS
    ln_co PLS_INTEGER;
  BEGIN
    BEGIN
      SELECT COUNT(1)
        INTO ln_co
        FROM MPS.ev_owner_ev_type eoet
       WHERE eoet.ev_owner_id = eventownerid
         AND eoet.ev_type_id = eventtypeid;
    EXCEPTION
      WHEN OTHERS THEN
        ln_co := 0;
    END;
    IF ln_co <> 0 THEN
    
      BEGIN
        DELETE FROM MPS.ev_owner_ev_type eoet
         WHERE eoet.ev_owner_id = eventownerid
           AND eoet.ev_type_id = eventtypeid;
      EXCEPTION
        WHEN OTHERS THEN
          MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                            p_ermsg  => SQLERRM,
                                            p_module => c_module,
                                            p_proc   => upper('EventOwnerToEventTypeDelete'));
      END;
      COMMIT;
    ELSE
      raise_application_error(-20001,
                              '50011, EventOwner to EventType connection can not be deleted. Such an entity does not exist, 1');
    END IF;
  END;

  PROCEDURE eventownerupdate(eventownerid NUMBER,
                             NAME         VARCHAR2,
                             description  VARCHAR2,
                             updatedby    VARCHAR2,
                             resdata      OUT SYS_REFCURSOR) IS
  
  BEGIN
    BEGIN
      UPDATE MPS.event_owner eo
         SET eo.src_name        = NAME,
             eo.src_description = description,
             eo.update_user_id  = updatedby,
             eo.date_updated    = SYSDATE
       WHERE eventownerid = eventownerid;
    EXCEPTION
      WHEN OTHERS THEN
        MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                          p_ermsg  => SQLERRM,
                                          p_module => c_module,
                                          p_proc   => upper('EventOwnerUpdate'));
    END;
    COMMIT;
  
    SELECT e.* BULK COLLECT INTO t_tab FROM MPS.sms_log_errors e;
  
    OPEN resdata FOR
      SELECT * FROM TABLE(MPS.pkg_sms_module.get_ttab);
  END;

  -------------------------------------------------------------------------------------------------------------------

  PROCEDURE eventownerupdateactive(eventownerid NUMBER,
                                   isactive     NUMBER,
                                   updatedby    VARCHAR2,
                                   resdata      OUT SYS_REFCURSOR) IS
  
  BEGIN
    BEGIN
      UPDATE MPS.event_owner eo
         SET eo.is_active      = isactive,
             eo.update_user_id = updatedby,
             eo.date_updated   = SYSDATE
       WHERE eo.id = eventownerid;
    EXCEPTION
      WHEN OTHERS THEN
        MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                          p_ermsg  => SQLERRM,
                                          p_module => c_module,
                                          p_proc   => upper('EventOwnerUpdate'));
    END;
    COMMIT;
  
    SELECT e.* BULK COLLECT INTO t_tab FROM MPS.sms_log_errors e;
  
    OPEN resdata FOR
      SELECT * FROM TABLE(MPS.pkg_sms_module.get_ttab);
  END;

  PROCEDURE eventprocessingexpirationstatusset IS
    l_id dbms_sql.number_table;
  
  BEGIN
  
    SELECT ep.id
      BULK COLLECT
      INTO l_id
      FROM MPS.event_processing ep
      LEFT JOIN (SELECT MAX(id) AS id, ev_proc_id, ev_proc_req_status_id
                   FROM MPS.event_process_request
                  GROUP BY ev_proc_id, ev_proc_req_status_id) epr
        ON ep.id = epr.ev_proc_id, MPS.event_handler eh, MPS.event_upload eu
     WHERE ep.ev_hand_id = eh.id
          
       AND eu.id = ep.ev_upl_id
       AND ep.ev_proc_status_id IN (1, 2)
       AND (epr.id IS NULL OR epr.ev_proc_req_status_id IN (1, 10, 20))
       AND ((SYSDATE - eu.date_created) * 24 * 60 * 60) > eh.expir_timesec;
  
    IF l_id.count > 0 THEN
      FORALL i IN 1 .. l_id.count
      
        UPDATE MPS.event_process_request epr
           SET epr.ev_proc_req_status_id = 40, epr.date_updated = SYSDATE
         WHERE epr.ev_proc_id = l_id(i)
           AND epr.ev_proc_req_status_id IN (1, 10, 20);
    
    END IF;
  
    IF l_id.count > 0 THEN
      FORALL j IN 1 .. l_id.count
      
        UPDATE MPS.event_processing ep
           SET ep.ev_proc_status_id = 3,
               ep.error_code        = 50004,
               ep.error_descriptor  = 'Event expired',
               ep.date_updated      = SYSDATE
         WHERE ep.id = l_id(j);
    END IF;
  
  END;

  PROCEDURE /*eventprocessingexternalidbatchget*/
   p_ep_external_batchget(processingcount      NUMBER,
                          reprocessingdelaysec NUMBER,
                          resdata              OUT SYS_REFCURSOR) IS
    ln_idsess NUMBER;
    --l_err     PLS_INTEGER;
  BEGIN
    ln_idsess := userenv('sessionid');
    DELETE FROM MPS.tmp_external_result;
    COMMIT;
    BEGIN
      INSERT INTO MPS.tmp_external_result
      
      /*   SELECT eventprocessingrequestid, external_id
      \*BULK COLLECT
      INTO l_reqid, l_extid --, t_data*\
        FROM (SELECT epr.id eventprocessingrequestid,
                     epr.external_id,
                     epr.date_snd_lastsync
                FROM MPS.event_process_request epr
               WHERE epr.external_id IS NOT NULL
                 AND epr.ev_proc_req_status_id = 60
                 AND (epr.date_snd_lastsync IS NULL OR
                     ((SYSDATE - epr.date_snd_lastsync) * 24 * 60 * 60) >
                     reprocessingdelaysec)
               ORDER BY epr.date_created)
       WHERE rownum <= processingcount;*/
      
        SELECT eventprocessingrequestid,
               external_id,
               businessline,
               messagetype,
               isdeliveryguaranteed
          FROM (SELECT epr.id                    eventprocessingrequestid,
                       epr.external_id,
                       epr.date_snd_lastsync,
                       eh.business_line          businessline,
                       eh.message_type           messagetype,
                       eh.is_delivery_guaranteed isdeliveryguaranteed
                  FROM MPS.event_process_request epr,
                       MPS.event_processing      ep,
                       MPS.event_handler         eh
                 WHERE epr.ev_proc_id = ep.id
                   AND eh.id = ep.ev_hand_id
                   AND epr.external_id IS NOT NULL
                   AND epr.ev_proc_req_status_id = 60
                   AND (epr.date_snd_lastsync IS NULL OR
                       ((SYSDATE - epr.date_snd_lastsync) * 24 * 60 * 60) >
                       reprocessingdelaysec)
                 ORDER BY epr.date_created)
         WHERE rownum <= processingcount;
    
    EXCEPTION
      WHEN OTHERS THEN
        MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                          p_ermsg  => SQLERRM,
                                          p_module => c_module,
                                          p_proc   => upper('INSERT INTO MPS.tmp_external_result'),
                                          p_idsess => ln_idsess);
    END;
    BEGIN
      -- IF l_reqid.count > 0 THEN
      --FORALL i IN 1 .. l_reqid.count
      -- l_reqid(i);
    
      MERGE INTO MPS.event_process_request ep
      USING (SELECT ted.eventprocessingrequestid
               FROM MPS.tmp_external_result ted) p
      ON (ep.id = p.eventprocessingrequestid)
      WHEN MATCHED THEN
        UPDATE SET ep.date_snd_lastsync = SYSDATE;
    
      --END IF;
    
      SELECT e.* BULK COLLECT INTO t_data FROM MPS.tmp_external_result e;
    
      OPEN resdata FOR
        SELECT * FROM TABLE(MPS.pkg_sms_module.get_data);
    
    EXCEPTION
      WHEN OTHERS THEN
        MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                          p_ermsg  => SQLERRM,
                                          p_module => c_module,
                                          p_proc   => upper('eventprocessingexternalidbatchget'),
                                          p_idsess => ln_idsess);
    END;
    COMMIT;
  
  END;

  PROCEDURE p_evproc_req_exter_update(eventprocessingrequestid NUMBER,
                                      eventstatus           NUMBER,
                                      sendedtemplateversion VARCHAR2,
                                      sendedmessagebody     VARCHAR2,
                                      externalid            VARCHAR2) IS --eventprocessingrequestexternalidupdate
  BEGIN
    BEGIN
      UPDATE MPS.event_process_request epr
         SET epr.snd_temp_vers         = sendedtemplateversion,
             epr.snd_mess_body         = sendedmessagebody,
             epr.external_id           = externalid,
             epr.date_sended           = SYSDATE,
             epr.ev_proc_req_status_id = eventstatus
       WHERE epr.id = eventprocessingrequestid;
    EXCEPTION
      WHEN OTHERS THEN
        MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                          p_ermsg  => SQLERRM,
                                          p_module => c_module,
                                          p_proc   => upper('EventProcessingRequestExternalIdUpdate'));
    END;
    COMMIT;
  END;

  PROCEDURE p_evproc_req_status_update(eventprocessingrequestid NUMBER,
                                       eventstatus              NUMBER,
                                       errorcode                NUMBER,
                                       errordescription         VARCHAR2) IS --EventProcessingRequestStatusUpdate
  BEGIN
  
    BEGIN
      UPDATE MPS.event_process_request epr
         SET ev_proc_req_status_id = eventstatus,
             epr.date_updated      = SYSDATE,
             epr.error_code        = errorcode,
             epr.error_descriptor  = errordescription
       WHERE id = eventprocessingrequestid;
    EXCEPTION
      WHEN OTHERS THEN
        MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                          p_ermsg  => SQLERRM,
                                          p_module => c_module,
                                          p_proc   => upper('eventprocessingrequeststatusupdate'));
    END;
  
    COMMIT;
    BEGIN
      p_event_processing_upd(p_ev_proc_req_id => eventprocessingrequestid);
    
    EXCEPTION
      WHEN OTHERS THEN
        MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                          p_ermsg  => SQLERRM,
                                          p_module => c_module,
                                          p_proc   => upper('p_event_processing_upd'));
    END;
  END;

  PROCEDURE eventtypeadd(NAME         VARCHAR2,
                         description  VARCHAR2,
                         eventownerid NUMBER,
                         createdby    VARCHAR2,
                         resdata      OUT SYS_REFCURSOR) IS
    v_id  PLS_INTEGER;
    ln_co PLS_INTEGER;
  BEGIN
    DELETE FROM MPS.tmp_inserted;
    COMMIT;
    BEGIN
      INSERT INTO MPS.event_type
        (ev_name, ev_descriptor, is_active, create_user_id, date_created)
      
      VALUES
        (NAME, description, 1, createdby, SYSDATE)
      RETURNING id INTO v_id;
      INSERT INTO MPS.tmp_inserted VALUES (v_id);
    
      BEGIN
        SELECT ti.id
          INTO ln_co
          FROM MPS.tmp_inserted ti
         WHERE rownum <= 1;
      EXCEPTION
        WHEN OTHERS THEN
          ln_co := 0;
      END;
      IF ln_co <> 0 AND eventownerid <> 0 THEN
        MPS.pkg_sms_module.eventownertoeventtypeadd(eventownerid => eventownerid,
                                                     eventtypeid  => ln_co,
                                                     createdby    => createdby);
      END IF;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                          p_ermsg  => SQLERRM,
                                          p_module => c_module,
                                          p_proc   => upper('eventtypeadd'));
    END;
  
    SELECT e.* BULK COLLECT INTO t_tab FROM MPS.sms_log_errors e;
  
    OPEN resdata FOR
      SELECT * FROM TABLE(MPS.pkg_sms_module.get_ttab);
  END;

  PROCEDURE eventtypeupdate(eventtypeid NUMBER,
                            NAME        VARCHAR2,
                            description VARCHAR2,
                            updatedby   VARCHAR2,
                            resdata     OUT SYS_REFCURSOR) IS
  
  BEGIN
    BEGIN
      UPDATE MPS.event_type et
         SET et.ev_name        = NAME,
             et.ev_descriptor  = description,
             et.update_user_id = updatedby,
             et.date_updated   = SYSDATE
       WHERE eventtypeid = eventtypeid;
    EXCEPTION
      WHEN OTHERS THEN
        MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                          p_ermsg  => SQLERRM,
                                          p_module => c_module,
                                          p_proc   => upper('eventtypeadd'));
    END;
    SELECT e.* BULK COLLECT INTO t_tab FROM MPS.sms_log_errors e;
  
    OPEN resdata FOR
      SELECT * FROM TABLE(MPS.pkg_sms_module.get_ttab);
  END;

  PROCEDURE sendersystemupdateactive(sendersystemid NUMBER,
                                     isactive       NUMBER,
                                     updatedby      VARCHAR2,
                                     resdata        OUT SYS_REFCURSOR) IS
  
  BEGIN
    BEGIN
      UPDATE MPS.sender_system ss
         SET ss.is_active      = isactive,
             ss.update_user_id = updatedby,
             ss.date_updated   = SYSDATE
       WHERE ss.id = sendersystemid;
    
    EXCEPTION
      WHEN OTHERS THEN
        MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                          p_ermsg  => SQLERRM,
                                          p_module => c_module,
                                          p_proc   => upper('SenderSystemUpdateActive'));
    END;
    SELECT e.* BULK COLLECT INTO t_tab FROM MPS.sms_log_errors e;
  
    OPEN resdata FOR
      SELECT * FROM TABLE(MPS.pkg_sms_module.get_ttab);
  END;

  PROCEDURE eventtypeupdateactive(eventtypeid NUMBER,
                                  isactive    NUMBER,
                                  updatedby   VARCHAR2,
                                  resdata     OUT SYS_REFCURSOR) IS
  
  BEGIN
    BEGIN
    
      UPDATE MPS.event_type et
         SET et.is_active      = isactive,
             et.update_user_id = updatedby,
             et.date_updated   = SYSDATE
       WHERE eventtypeid = eventtypeid;
    
    EXCEPTION
      WHEN OTHERS THEN
        MPS.pkg_sms_module_log.p_log_ins(p_ercode => 500,
                                          p_ermsg  => SQLERRM,
                                          p_module => c_module,
                                          p_proc   => upper('EventTypeUpdateActive'));
    END;
    SELECT e.* BULK COLLECT INTO t_tab FROM MPS.sms_log_errors e;
  
    OPEN resdata FOR
      SELECT * FROM TABLE(MPS.pkg_sms_module.get_ttab);
  END;

  PROCEDURE sendersystemupdate(sendersystemid NUMBER,
                               NAME           VARCHAR2,
                               description    VARCHAR2,
                               updatedby      VARCHAR2,
                               resdata        OUT SYS_REFCURSOR) IS
  
  BEGIN
    BEGIN
    
      UPDATE MPS.sender_system ss
         SET ss.snd_sysname       = NAME,
             ss.snd_sysdescriptor = description,
             ss.update_user_id    = updatedby,
             ss.date_updated      = SYSDATE
       WHERE sendersystemid = sendersystemid;
    
    EXCEPTION
      WHEN OTHERS THEN
        MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                          p_ermsg  => SQLERRM,
                                          p_module => c_module,
                                          p_proc   => upper('SenderSystemUpdate'));
    END;
    SELECT e.* BULK COLLECT INTO t_tab FROM MPS.sms_log_errors e;
  
    OPEN resdata FOR
      SELECT * FROM TABLE(MPS.pkg_sms_module.get_ttab);
  END;

  PROCEDURE sendersystemadd(NAME        VARCHAR2,
                            description VARCHAR2,
                            createdby   VARCHAR2,
                            resdata     OUT SYS_REFCURSOR) IS
  
  BEGIN
    BEGIN
    
      INSERT INTO MPS.sender_system
        (snd_sysname,
         snd_sysdescriptor,
         is_active,
         create_user_id,
         date_created)
      VALUES
        (NAME, description, 1, createdby, SYSDATE);
    
    EXCEPTION
      WHEN OTHERS THEN
        MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                          p_ermsg  => SQLERRM,
                                          p_module => c_module,
                                          p_proc   => upper('SenderSystemAdd'));
    END;
    SELECT e.* BULK COLLECT INTO t_tab FROM MPS.sms_log_errors e;
  
    OPEN resdata FOR
      SELECT * FROM TABLE(MPS.pkg_sms_module.get_ttab);
  END;

  PROCEDURE messagetemplateupdate(messagetemplateid   NUMBER,
                                  eventhandlerid      NUMBER,
                                  messagetemplatebody VARCHAR2,
                                  isactive            NUMBER,
                                  updatedby           VARCHAR2,
                                  resdata             OUT SYS_REFCURSOR) IS
  
  BEGIN
    BEGIN
    
      UPDATE MPS.message_template mt
         SET mt.ev_handler_id  = eventhandlerid,
             mt.mess_temp_body = messagetemplatebody,
             mt.is_active      = isactive,
             mt.update_user_id = updatedby,
             mt.date_updated   = SYSDATE
       WHERE messagetemplateid = messagetemplateid;
    
    EXCEPTION
      WHEN OTHERS THEN
        MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                          p_ermsg  => SQLERRM,
                                          p_module => c_module,
                                          p_proc   => upper('MessageTemplateUpdate'));
    END;
    SELECT e.* BULK COLLECT INTO t_tab FROM MPS.sms_log_errors e;
  
    OPEN resdata FOR
      SELECT * FROM TABLE(MPS.pkg_sms_module.get_ttab);
  END;

  PROCEDURE messagetemplateadd(eventhandlerid      NUMBER,
                               messagetemplatebody VARCHAR2,
                               createdby           VARCHAR2,
                               resdata             OUT SYS_REFCURSOR) IS
  
  BEGIN
    BEGIN
    
      UPDATE MPS.message_template mt
         SET is_active = 0
       WHERE ev_handler_id = eventhandlerid;
    
      INSERT INTO MPS.message_template
        (ev_handler_id,
         mess_temp_id,
         mess_temp_body,
         is_active,
         create_user_id,
         date_created)
      VALUES
        (eventhandlerid,
         sys_guid(),
         messagetemplatebody,
         1,
         createdby,
         SYSDATE);
    
    EXCEPTION
      WHEN OTHERS THEN
        MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                          p_ermsg  => SQLERRM,
                                          p_module => c_module,
                                          p_proc   => upper('MessageTemplateAdd'));
    END;
    SELECT e.* BULK COLLECT INTO t_tab FROM MPS.sms_log_errors e;
  
    OPEN resdata FOR
      SELECT * FROM TABLE(MPS.pkg_sms_module.get_ttab);
  END;
  -- вернуть колво данніх (rescount) из таблиці  MPS.tmp_evproc_dequeued вместо resdata
  PROCEDURE eventuploadtoprocessing(processingcount NUMBER,
                                    -- resdata         OUT SYS_REFCURSOR,
                                    p_cnt  OUT NUMBER,
                                    reserr OUT SYS_REFCURSOR) IS
    l_co PLS_INTEGER;
    --l_err     PLS_INTEGER;
    ln_idsess NUMBER;
    lnco      PLS_INTEGER;
  BEGIN
    DELETE FROM MPS.tmp_evproc_dequeued;
    COMMIT;
    ln_idsess := userenv('sessionid');
    --dbms_output.put_line(ln_idsess);
    FOR ii IN (SELECT eventuploadid, eventreferenceuid
                 FROM (SELECT eu.id           eventuploadid,
                              eu.ev_ref_id    eventreferenceuid,
                              eu.status_id    statusid,
                              eu.date_updated updateddatetime
                         FROM MPS.event_upload eu
                        WHERE eu.status_id = 1 --New
                          AND eu.status_upload_id = 1
                        ORDER BY eu.date_created)
                WHERE rownum <= processingcount)
    LOOP
      BEGIN
        UPDATE MPS.event_upload eu
           SET status_id = 2, date_updated = SYSDATE
         WHERE eu.id = ii.eventuploadid;
      EXCEPTION
        WHEN OTHERS THEN
          MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                            p_ermsg  => SQLERRM,
                                            p_module => c_module,
                                            p_proc   => ' UPDATE event_upload ' ||
                                                        upper('eventuploadtoprocessing'),
                                            p_idsess => ln_idsess);
      END;
    
      BEGIN
        INSERT INTO MPS.tmp_evproc_dequeued
          (eventuploadid, eventreferenceuid)
        VALUES
          (ii.eventuploadid, ii.eventreferenceuid);
      EXCEPTION
        WHEN OTHERS THEN
          MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                            p_ermsg  => SQLERRM,
                                            p_module => c_module,
                                            p_proc   => ' INSERT tmp_evproc_dequeued' ||
                                                        upper('eventuploadtoprocessing'),
                                            p_idsess => ln_idsess);
      END;
    END LOOP;
  
    BEGIN
      SELECT COUNT(1)
        INTO l_co
        FROM MPS.tmp_evproc_dequeued ted
       WHERE rownum <= 1;
    EXCEPTION
      WHEN OTHERS THEN
        l_co := 0;
    END;
  
    IF l_co <> 0 THEN
      BEGIN
        INSERT INTO MPS.event_processing ep
          (ev_upl_id, ev_ref_id, date_created)
          SELECT eventuploadid, eventreferenceuid, SYSDATE
            FROM MPS.tmp_evproc_dequeued;
      EXCEPTION
        WHEN OTHERS THEN
          MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                            p_ermsg  => SQLERRM,
                                            p_module => c_module,
                                            p_proc   => ' INSERT event_processing' ||
                                                        upper('eventuploadtoprocessing'));
      END;
    END IF;
  
    BEGIN
      SELECT COUNT(1)
        INTO lnco
        FROM MPS.sms_log_errors t
       WHERE t.id_sess = ln_idsess;
    EXCEPTION
      WHEN OTHERS THEN
        lnco := -1;
    END;
    IF lnco = 0 THEN
      COMMIT;
    ELSE
      ROLLBACK;
    END IF;
  
    BEGIN
      SELECT COUNT(1) cnt INTO p_cnt FROM MPS.tmp_evproc_dequeued;
    EXCEPTION
      WHEN OTHERS THEN
        p_cnt := -1;
    END;
    SELECT e.*
      BULK COLLECT
      INTO t_tab
      FROM MPS.sms_log_errors e
     WHERE e.id_sess = ln_idsess;
  
    OPEN reserr FOR
      SELECT * FROM TABLE(MPS.pkg_sms_module.get_ttab);
  
  END;

  PROCEDURE p_trg_event_processing_upd(p_newsts IN NUMBER,
                                       p_oldsts IN NUMBER) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  
  BEGIN
    IF p_newsts <> p_oldsts THEN
      MERGE INTO MPS.event_processing ep
      USING (SELECT ep.id,
                    ep.ev_upl_id,
                    ep.cnt_try,
                    eh.cnt_maxretry,
                    epr.ev_proc_req_status_id,
                    ep.ev_hand_id,
                    CASE
                      WHEN ep.cnt_try = eh.cnt_maxretry THEN
                       -1
                      ELSE
                       0
                    END pri
               FROM MPS.event_process_request epr,
                    MPS.event_processing      ep,
                    MPS.event_handler         eh
              WHERE epr.ev_proc_id = ep.id
                AND eh.id = ep.ev_hand_id
                AND epr.ev_proc_req_status_id = 80
                AND CASE
                      WHEN ep.cnt_try = eh.cnt_maxretry THEN
                       -1
                      ELSE
                       0
                    END = -1) p
      ON (p.id = ep.id)
      WHEN MATCHED THEN
        UPDATE
           SET ep.ev_proc_status_id = 3,
               ep.date_updated      = SYSDATE,
               
               ep.error_code       = 50003,
               ep.error_descriptor = 'TryCount exceeded the limits';
    
      MERGE INTO MPS.event_upload eu
      
      USING (SELECT ep.ev_upl_id,
                    CASE
                      WHEN ep.cnt_try = eh.cnt_maxretry THEN
                       -1
                      ELSE
                       0
                    END pri
               FROM MPS.event_process_request epr,
                    MPS.event_processing      ep,
                    MPS.event_handler         eh
              WHERE epr.ev_proc_id = ep.id
                AND eh.id = ep.ev_hand_id
                AND epr.ev_proc_req_status_id = 80
                AND CASE
                      WHEN ep.cnt_try = eh.cnt_maxretry THEN
                       -1
                      ELSE
                       0
                    END = -1) p
      ON (p.ev_upl_id = eu.id)
      WHEN MATCHED THEN
        UPDATE
           SET eu.status_id        = 4,
               eu.date_updated     = SYSDATE,
               eu.error_code       = 50003,
               eu.error_descriptor = 'TryCount exceeded the limits';
    
      MERGE INTO MPS.event_processing ep
      
      USING (SELECT ep.id
               FROM MPS.event_process_request epr, MPS.event_processing ep
              WHERE epr.ev_proc_id = ep.id
                AND epr.ev_proc_req_status_id = 90) p
      ON (p.id = ep.id)
      WHEN MATCHED THEN
        UPDATE SET ep.ev_proc_status_id = 4, date_updated = SYSDATE;
    
      MERGE INTO MPS.event_upload eu
      
      USING (SELECT ep.ev_upl_id
               FROM MPS.event_process_request epr, MPS.event_processing ep
              WHERE epr.ev_proc_id = ep.id
                AND epr.ev_proc_req_status_id = 90) p
      ON (p.ev_upl_id = eu.id)
      WHEN MATCHED THEN
        UPDATE SET eu.status_id = 5, eu.date_updated = SYSDATE;
    
    END IF;
  
    COMMIT;
  END;

  PROCEDURE p_event_processing_upd(p_ev_proc_req_id NUMBER) IS
  
  BEGIN
    --1 
    BEGIN
    
      MERGE INTO MPS.event_processing ep
      USING (SELECT ep.id,
                    ep.ev_upl_id,
                    ep.cnt_try,
                    eh.cnt_maxretry,
                    epr.ev_proc_req_status_id,
                    ep.ev_hand_id
               FROM MPS.event_process_request epr,
                    MPS.event_processing      ep,
                    MPS.event_handler         eh
              WHERE epr.ev_proc_id = ep.id
                AND eh.id = ep.ev_hand_id
                AND epr.ev_proc_req_status_id = 80
                AND epr.id = p_ev_proc_req_id
                AND ep.cnt_try = eh.cnt_maxretry) p
      ON (p.id = ep.id)
      WHEN MATCHED THEN
        UPDATE
           SET ep.ev_proc_status_id = 3,
               ep.date_updated      = SYSDATE,
               
               ep.error_code       = 50003,
               ep.error_descriptor = 'TryCount exceeded the limits';
    EXCEPTION
      WHEN OTHERS THEN
        MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                          p_ermsg  => SQLERRM,
                                          p_module => c_module,
                                          p_proc   => upper('--1 MERGE INTO MPS.event_processing, ev_proc_status_id = 3 '));
    END;
    --2
    BEGIN
      MERGE INTO MPS.event_processing ep
      
      USING (SELECT ep.id
               FROM MPS.event_process_request epr, MPS.event_processing ep
              WHERE epr.ev_proc_id = ep.id
                AND epr.ev_proc_req_status_id = 90
                AND epr.id = p_ev_proc_req_id) p
      ON (p.id = ep.id)
      WHEN MATCHED THEN
        UPDATE SET ep.ev_proc_status_id = 4, date_updated = SYSDATE;
    EXCEPTION
      WHEN OTHERS THEN
        MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                          p_ermsg  => SQLERRM,
                                          p_module => c_module,
                                          p_proc   => upper('--2 MERGE INTO MPS.event_processing, ev_proc_status_id = 4 '));
    END;
  
    COMMIT;
  
    BEGIN
      p_event_upload_upd(p_ev_proc_req_id => p_ev_proc_req_id);
    
    EXCEPTION
      WHEN OTHERS THEN
        MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                          p_ermsg  => SQLERRM,
                                          p_module => c_module,
                                          p_proc   => upper('p_event_upload_upd'));
    END;
  
  END;

  PROCEDURE p_event_upload_upd(p_ev_proc_req_id NUMBER) IS
  
  BEGIN
    BEGIN
      MERGE INTO MPS.event_upload eu
      
      USING (SELECT ep.ev_upl_id
               FROM MPS.event_process_request epr,
                    MPS.event_processing      ep,
                    MPS.event_handler         eh
              WHERE epr.ev_proc_id = ep.id
                AND eh.id = ep.ev_hand_id
                AND epr.ev_proc_req_status_id = 80
                AND epr.id = p_ev_proc_req_id
                AND ep.cnt_try = eh.cnt_maxretry) p
      ON (p.ev_upl_id = eu.id)
      WHEN MATCHED THEN
        UPDATE
           SET eu.status_id        = 4,
               eu.date_updated     = SYSDATE,
               eu.error_code       = 50003,
               eu.error_descriptor = 'TryCount exceeded the limits';
    EXCEPTION
      WHEN OTHERS THEN
        MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                          p_ermsg  => SQLERRM,
                                          p_module => c_module,
                                          p_proc   => upper('--1 MERGE INTO MPS.event_upload,status_id = 4 '));
    END;
    BEGIN
      MERGE INTO MPS.event_upload eu
      
      USING (SELECT ep.ev_upl_id
               FROM MPS.event_process_request epr, MPS.event_processing ep
              WHERE epr.ev_proc_id = ep.id
                AND epr.ev_proc_req_status_id = 90
                AND epr.id = p_ev_proc_req_id) p
      ON (p.ev_upl_id = eu.id)
      WHEN MATCHED THEN
        UPDATE SET eu.status_id = 5, eu.date_updated = SYSDATE;
    EXCEPTION
      WHEN OTHERS THEN
        MPS.pkg_sms_module_log.p_log_ins(p_ercode => SQLCODE,
                                          p_ermsg  => SQLERRM,
                                          p_module => c_module,
                                          p_proc   => upper('--2 MERGE INTO MPS.event_upload,status_id = 5 '));
    END;
    COMMIT;
  
  END;

BEGIN
  NULL;
END pkg_sms_module;
/

```