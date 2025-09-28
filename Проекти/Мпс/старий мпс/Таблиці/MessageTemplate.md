-- Create table

create table MPS.MESSAGE_TEMPLATE

(

  id             NUMBER not null,

  ev_handler_id  NUMBER not null,

  mess_temp_id   VARCHAR2(100) not null,

  mess_temp_body VARCHAR2(4000) not null,

  is_active      NUMBER not null,

  create_user_id VARCHAR2(100) not null,

  date_created   DATE not null,

  update_user_id VARCHAR2(100),

  date_updated   DATE

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

comment on table MPS.MESSAGE_TEMPLATE

  is 'SMS module(Таблица шаблонов сообщений)';

-- Add comments to the columns

comment on column MPS.MESSAGE_TEMPLATE.id

  is 'ID записи';

comment on column MPS.MESSAGE_TEMPLATE.ev_handler_id

  is 'ID записи в таблице EventHandler';

comment on column MPS.MESSAGE_TEMPLATE.mess_temp_id

  is 'Уникальный идентификатор версии шаблона';

comment on column MPS.MESSAGE_TEMPLATE.mess_temp_body

  is 'Тело шаблона';

comment on column MPS.MESSAGE_TEMPLATE.is_active

  is 'Признак активности';

comment on column MPS.MESSAGE_TEMPLATE.create_user_id

  is 'ID пользователя, создавшего обработчик';

comment on column MPS.MESSAGE_TEMPLATE.date_created

  is 'Дата и время добавления записи';

comment on column MPS.MESSAGE_TEMPLATE.update_user_id

  is 'ID пользователя, внесшего изменения в обработчик';

comment on column MPS.MESSAGE_TEMPLATE.date_updated

  is 'Дата и время последнего обновления записи';

-- Create/Recreate primary, unique and foreign key constraints

alter table MPS.MESSAGE_TEMPLATE

  add constraint PK_MESSAGE_TEMPLATE primary key (ID)

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

alter table MPS.MESSAGE_TEMPLATE

  add constraint FK_EV_HND foreign key (EV_HANDLER_ID)

  references MPS.EVENT_HANDLER (ID);