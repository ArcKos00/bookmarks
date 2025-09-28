-- Create table

create table MPS.LOG_EVENT_HANDLER

(

  id                     NUMBER not null,

  ev_hand_id             NUMBER not null,

  ev_name                VARCHAR2(100) not null,

  ev_descriptor          VARCHAR2(1000) not null,

  ev_owner_id            NUMBER not null,

  ev_type_id             NUMBER not null,

  delivery_type_id       NUMBER not null,

  priority               NUMBER not null,

  cnt_maxretry           NUMBER,

  per_retry_sec          NUMBER,

  snd_start_time         VARCHAR2(100) not null,

  snd_stop_time          VARCHAR2(100) not null,

  snd_onweekends         NUMBER not null,

  expir_timesec          NUMBER,

  is_active              NUMBER not null,

  create_user_id         VARCHAR2(100) not null,

  date_created           DATE not null,

  update_user_id         VARCHAR2(100),

  date_updated           DATE,

  log_update_user_id     VARCHAR2(100),

  log_date_updated       DATE,

  business_line          VARCHAR2(100),

  message_type           VARCHAR2(100),

  is_delivery_guaranteed NUMBER

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

comment on table MPS.LOG_EVENT_HANDLER

  is 'SMS module(Таблица аудита для таблицы EventHandler)';

-- Add comments to the columns

comment on column MPS.LOG_EVENT_HANDLER.id

  is 'ID записи';

comment on column MPS.LOG_EVENT_HANDLER.ev_hand_id

  is 'ID записи в таблице EventHandler';

comment on column MPS.LOG_EVENT_HANDLER.ev_name

  is 'Наименование обработчика событий';

comment on column MPS.LOG_EVENT_HANDLER.ev_descriptor

  is 'Краткое описание обработчика событий';

comment on column MPS.LOG_EVENT_HANDLER.ev_owner_id

  is 'Система-источник события. ';

comment on column MPS.LOG_EVENT_HANDLER.ev_type_id

  is 'Тип события. ';

comment on column MPS.LOG_EVENT_HANDLER.delivery_type_id

  is 'Способ отправки сообщений.';

comment on column MPS.LOG_EVENT_HANDLER.priority

  is 'Приоритет обработки/отправки.';

comment on column MPS.LOG_EVENT_HANDLER.cnt_maxretry

  is 'Максимальное количество попыток обработки';

comment on column MPS.LOG_EVENT_HANDLER.per_retry_sec

  is 'Время между попытками обработки (в секундах)';

comment on column MPS.LOG_EVENT_HANDLER.snd_start_time

  is 'Допустимое время начала отправки';

comment on column MPS.LOG_EVENT_HANDLER.snd_stop_time

  is 'Допустимое время окончания отправки';

comment on column MPS.LOG_EVENT_HANDLER.snd_onweekends

  is '"Возможность отправки в выходные дни0 – отправка в выходные дни запрещена1 – отправка в выходные дни разрешена"';

comment on column MPS.LOG_EVENT_HANDLER.expir_timesec

  is 'Максимальное время жизни события (в секундах)';

comment on column MPS.LOG_EVENT_HANDLER.is_active

  is 'Признак активности';

comment on column MPS.LOG_EVENT_HANDLER.update_user_id

  is 'ID пользователя, внесшего изменения';

comment on column MPS.LOG_EVENT_HANDLER.date_updated

  is 'Дата и время изменений';

comment on column MPS.LOG_EVENT_HANDLER.business_line

  is 'Справочник ESB. Бизнес линия';

comment on column MPS.LOG_EVENT_HANDLER.message_type

  is 'Справочник ESB. Тип сообщения';

comment on column MPS.LOG_EVENT_HANDLER.is_delivery_guaranteed

  is 'Признак гарантированности доставки.';

-- Create/Recreate primary, unique and foreign key constraints

alter table MPS.LOG_EVENT_HANDLER

  add constraint PK_LOG_EVENT_HANDLER primary key (ID)

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