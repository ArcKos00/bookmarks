-- Create table

create global temporary table MPS.TMP_EVPROC_DEQUEUED

(

  eventprocessingid        NUMBER,

  eventreferenceuid        VARCHAR2(4000),

  eventuploadid            NUMBER,

  eventhandlerid           NUMBER,

  statusid                 NUMBER,

  trycount                 NUMBER,

  eventprocessingrequestid NUMBER,

  requeststatusid          NUMBER

)

on commit preserve rows;

-- Add comments to the table

comment on table MPS.TMP_EVPROC_DEQUEUED

  is 'временная для процедуры EventProcessingBatchGet';