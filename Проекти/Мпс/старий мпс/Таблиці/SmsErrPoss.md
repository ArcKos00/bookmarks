```
-- Create table

create global temporary table MPS.SMS_ERR_POSS

(

  errorcode    NUMBER,

  errormessage VARCHAR2(100)

)

on commit preserve rows;
```