-- Create table

create global temporary table MPS.TMP_EVPROC_RESULT

(

  eventprocessingrequestid NUMBER,

  eventreferenceuid        VARCHAR2(4000)

)

on commit preserve rows;

-- Add comments to the table

comment on table MPS.TMP_EVPROC_RESULT

  is 'временная для процедуры EventProcessingBatchGet';