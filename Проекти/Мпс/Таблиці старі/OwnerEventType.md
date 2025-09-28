-- Create table

create table MPS.EV_OWNER_EV_TYPE

(

  ev_owner_id    NUMBER not null,

  ev_type_id     NUMBER not null,

  create_user_id VARCHAR2(100) not null,

  date_created   DATE not null

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

comment on table MPS.EV_OWNER_EV_TYPE

  is 'SMS module(Таблица связей EventOwner к EventType)';

-- Add comments to the columns

comment on column MPS.EV_OWNER_EV_TYPE.ev_owner_id

  is 'ID записи в таблице EventOwner';

comment on column MPS.EV_OWNER_EV_TYPE.ev_type_id

  is 'ID записи в таблице EventType';

comment on column MPS.EV_OWNER_EV_TYPE.create_user_id

  is 'ID пользователя, создавшего запись';

comment on column MPS.EV_OWNER_EV_TYPE.date_created

  is 'Дата и время добавления записи';

-- Create/Recreate primary, unique and foreign key constraints

alter table MPS.EV_OWNER_EV_TYPE

  add constraint FK_EV_OWNR_ID foreign key (EV_OWNER_ID)

  references MPS.EVENT_OWNER (ID);

alter table MPS.EV_OWNER_EV_TYPE

  add constraint FK_EV_TYPE_ID foreign key (EV_TYPE_ID)

  references MPS.EVENT_TYPE (ID);