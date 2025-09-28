-- Create table

create table MPS.EVENT_PARAMETERS

(

  id            NUMBER,

  ev_code       VARCHAR2(100),

  ev_param_name VARCHAR2(100),

  description   VARCHAR2(4000)

)

tablespace TS_MPS

  pctfree 10

  initrans 1

  maxtrans 255

  storage

  (

    initial 64K

    next 1M

    minextents 1

    maxextents unlimited

  );

-- Add comments to the table

comment on table MPS.EVENT_PARAMETERS

  is 'sms module, name parameters';