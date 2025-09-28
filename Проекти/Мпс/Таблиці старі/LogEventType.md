-- Create table

create table MPS.LOG_EVENT_TYPE

(

  id                 NUMBER not null,

  ev_type_id         NUMBER not null,

  ev_name            VARCHAR2(100) not null,

  ev_descriptor      VARCHAR2(1000) not null,

  is_active          NUMBER not null,

  create_user_id     VARCHAR2(32) not null,

  date_created       DATE not null,

  update_user_id     VARCHAR2(32),

  date_updated       DATE,

  log_update_user_id VARCHAR2(32),

  log_date_updated   DATE

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

comment on table MPS.LOG_EVENT_TYPE

  is 'SMS module(Таблица аудита для таблицы EventType)';

-- Add comments to the columns

comment on column MPS.LOG_EVENT_TYPE.id

  is 'ID записи';

comment on column MPS.LOG_EVENT_TYPE.ev_type_id

  is 'ID записи в таблице EventType';

comment on column MPS.LOG_EVENT_TYPE.ev_name

  is 'Наименование типа события';

comment on column MPS.LOG_EVENT_TYPE.ev_descriptor

  is 'Краткое описание типа события';

comment on column MPS.LOG_EVENT_TYPE.is_active

  is 'Признак активности';

comment on column MPS.LOG_EVENT_TYPE.update_user_id

  is 'ID пользователя, внесшего изменения';

comment on column MPS.LOG_EVENT_TYPE.date_updated

  is 'Дата и время изменений';

-- Create/Recreate primary, unique and foreign key constraints

alter table MPS.LOG_EVENT_TYPE

  add constraint PK_LOG_EVENT_TYPE primary key (ID)

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