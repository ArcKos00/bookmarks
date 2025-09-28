```
-- Create table

create table MPS.EVENT_PROCESS_STATUS

(

  id             NUMBER not null,

  eps_name       VARCHAR2(100) not null,

  eps_descriptor VARCHAR2(1000) not null

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

comment on table MPS.EVENT_PROCESS_STATUS

  is 'SMS module(Таблица статусов EventProcessing)';

-- Add comments to the columns

comment on column MPS.EVENT_PROCESS_STATUS.id

  is 'ID записи';

comment on column MPS.EVENT_PROCESS_STATUS.eps_name

  is 'Наименование статуса';

comment on column MPS.EVENT_PROCESS_STATUS.eps_descriptor

  is 'Краткое описание статуса';

-- Create/Recreate primary, unique and foreign key constraints

alter table MPS.EVENT_PROCESS_STATUS

  add constraint PK_EVENT_PROCESSING_STATUS primary key (ID)

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
```