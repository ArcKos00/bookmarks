```
-- Create table

create table MPS.EVENT_OWNER

(

  id              NUMBER not null,

  src_name        VARCHAR2(100) not null,

  src_description VARCHAR2(1000) not null,

  is_active       NUMBER not null,

  create_user_id  VARCHAR2(100) not null,

  date_created    DATE not null,

  update_user_id  VARCHAR2(100),

  date_updated    DATE

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

comment on table MPS.EVENT_OWNER

  is 'SMS module(Таблица систем-источников событий)';

-- Add comments to the columns

comment on column MPS.EVENT_OWNER.id

  is 'ID записи';

comment on column MPS.EVENT_OWNER.src_name

  is 'Наименование систем-источников';

comment on column MPS.EVENT_OWNER.src_description

  is 'Краткое описание систем-источников';

comment on column MPS.EVENT_OWNER.is_active

  is 'Признак активности';

comment on column MPS.EVENT_OWNER.create_user_id

  is 'ID пользователя, создавшего запись';

comment on column MPS.EVENT_OWNER.date_created

  is 'Дата и время добавления записи';

comment on column MPS.EVENT_OWNER.update_user_id

  is 'ID пользователя, внесшего изменения в запись';

comment on column MPS.EVENT_OWNER.date_updated

  is 'Дата и время последнего обновления записи';

-- Create/Recreate primary, unique and foreign key constraints

alter table MPS.EVENT_OWNER

  add constraint PK_EVENT_OWNER primary key (ID)

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