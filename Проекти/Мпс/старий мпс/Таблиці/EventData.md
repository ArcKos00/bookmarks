-- Create table

create table MPS.EVENT_DATA

(

  id        NUMBER not null,

  ev_upl_id NUMBER,

  ev_code   NUMBER,

  ev_data   VARCHAR2(500),

  status    NUMBER,

  batchid   NUMBER

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

comment on table MPS.EVENT_DATA

  is 'sms module данные по клиентам';

-- Add comments to the columns

comment on column MPS.EVENT_DATA.id

  is 'id ';

comment on column MPS.EVENT_DATA.ev_upl_id

  is 'id из event_upload';

comment on column MPS.EVENT_DATA.ev_code

  is 'название параметра';

comment on column MPS.EVENT_DATA.ev_data

  is 'содержимое';

comment on column MPS.EVENT_DATA.status

  is 'статус передачи данных 0 - вставлено,1 - зафиксировано';

comment on column MPS.EVENT_DATA.batchid

  is 'ID сессии ODI';

-- Create/Recreate indexes

create index MPS.IDX_EV_UPL on MPS.EVENT_DATA (EV_UPL_ID)

  tablespace TS_MPS

  pctfree 10

  initrans 2

  maxtrans 255

  storage

  (

    initial 64K

    next 1M

    minextents 1

    maxextents unlimited

  );

-- Create/Recreate primary, unique and foreign key constraints

alter table MPS.EVENT_DATA

  add constraint PK_KEY_DATA primary key (ID)

  using index

  tablespace TS_MPS

  pctfree 10

  initrans 2

  maxtrans 255

  storage

  (

    initial 64K

    next 1M

    minextents 1

    maxextents unlimited

  );