-- Create table

create table MPS.EVENT_UPLOAD_STATUS

(

  id              NUMBER not null,

  eus_name        VARCHAR2(100) not null,

  eus_descrtiptor VARCHAR2(1000) not null

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

comment on table MPS.EVENT_UPLOAD_STATUS

  is 'SMS module(Таблица статусов EventUpload)';

-- Add comments to the columns

comment on column MPS.EVENT_UPLOAD_STATUS.id

  is 'ID записи';

comment on column MPS.EVENT_UPLOAD_STATUS.eus_name

  is 'Наименование статуса';

comment on column MPS.EVENT_UPLOAD_STATUS.eus_descrtiptor

  is 'Краткое описание статуса';

-- Create/Recreate primary, unique and foreign key constraints

alter table MPS.EVENT_UPLOAD_STATUS

  add constraint PK_EVENT_UPLOAD_STATUS primary key (ID)

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