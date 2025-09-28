```
-- Create table

create global temporary table MPS.TMP_EXTERNAL_RESULT

(

  eventprocessingrequestid NUMBER,

  externalid               VARCHAR2(36),

  business_line            VARCHAR2(100),

  message_type             VARCHAR2(100),

  is_delivery_guaranteed   NUMBER

)

on commit preserve rows;
```