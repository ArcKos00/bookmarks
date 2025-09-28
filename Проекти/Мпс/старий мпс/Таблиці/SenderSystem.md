```
-- Create table

create table MPS.SENDER_SYSTEM

(

  id                NUMBER not null,

  snd_sysname       VARCHAR2(100) not null,

  snd_sysdescriptor VARCHAR2(1000) not null,

  is_active         NUMBER not null,

  create_user_id    VARCHAR2(100) not null,

  date_created      DATE not null,

  update_user_id    VARCHAR2(100),

  date_updated      DATE

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

comment on table MPS.SENDER_SYSTEM

  is 'SMS module(Таблица систем-отправителей)';

-- Add comments to the columns

comment on column MPS.SENDER_SYSTEM.id

  is 'ID записи';

comment on column MPS.SENDER_SYSTEM.snd_sysname

  is 'Наименование системы-отправителя';

comment on column MPS.SENDER_SYSTEM.snd_sysdescriptor

  is 'Краткое описание системы-отправителя';

comment on column MPS.SENDER_SYSTEM.is_active

  is 'Признак активности';

comment on column MPS.SENDER_SYSTEM.create_user_id

  is 'ID пользователя, создавшего запись';

comment on column MPS.SENDER_SYSTEM.date_created

  is 'Дата и время добавления записи';

comment on column MPS.SENDER_SYSTEM.update_user_id

  is 'ID пользователя, внесшего изменения в запись';

comment on column MPS.SENDER_SYSTEM.date_updated

  is 'Дата и время последнего обновления записи';

-- Create/Recreate primary, unique and foreign key constraints

alter table MPS.SENDER_SYSTEM

  add constraint PK_SENDER_SYSTEM primary key (ID)

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