-- Create table

create table MPS.DELIVERY_TYPE

(

  id             NUMBER not null,

  dlt_name       VARCHAR2(100) not null,

  dlt_descriptor VARCHAR2(1000) not null

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

comment on table MPS.DELIVERY_TYPE

  is 'SMS module(Таблица типов отправки)';

-- Add comments to the columns

comment on column MPS.DELIVERY_TYPE.id

  is 'ID записи';

comment on column MPS.DELIVERY_TYPE.dlt_name

  is 'Наименование типа отправки';

comment on column MPS.DELIVERY_TYPE.dlt_descriptor

  is 'Краткое описание типа отправки';

-- Create/Recreate primary, unique and foreign key constraints

alter table MPS.DELIVERY_TYPE

  add constraint PK_DELIVERY_TYPE primary key (ID)

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