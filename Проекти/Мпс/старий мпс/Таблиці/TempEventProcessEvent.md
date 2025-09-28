-- Create table

create global temporary table MPS.TMP_EVPROC_EVENT

(

  eventprocessingid              NUMBER,

  eventprocessingrequestid       NUMBER,

  eventprocessingstatusid        NUMBER,

  eventprocessingrequeststatusid NUMBER,

  trycount                       NUMBER,

  maxretrycount                  NUMBER,

  createddatetime                DATE,

  expirationtimesec              NUMBER,

  sendingonweekends              NUMBER,

  sendtimestart                  VARCHAR2(100),

  sendtimestop                   VARCHAR2(100)

)

on commit preserve rows;

-- Add comments to the table

comment on table MPS.TMP_EVPROC_EVENT

  is 'временная для процедуры(EventProcessingCheckSendingPossibility)  в пакете p_ev_proc_check_send_poss';