```
-- Create table

create table MPS.LOG_EVENT_UPLOAD

(

  id                 NUMBER not null,

  ev_uplod_id        NUMBER,

  ev_ref_id          RAW(16) not null,

  ev_owner_id        NUMBER not null,

  ev_type_id         NUMBER not null,

  ev_external_id     VARCHAR2(256),

  client_phone       VARCHAR2(20) not null,

  argumemnts_json    VARCHAR2(1000),

  snd_system_id      NUMBER not null,

  status_id          NUMBER not null,

  date_created       DATE not null,

  date_updated       DATE,

  error_code         NUMBER,

  error_descriptor   VARCHAR2(4000),

  status_upload_id   NUMBER,

  clid               NUMBER,

  contrid            NUMBER,

  batchid            NUMBER,

  log_update_user_id VARCHAR2(100),

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

comment on table MPS.LOG_EVENT_UPLOAD

  is 'SMS module(Загрузочная таблица для необработанных событий)';

-- Add comments to the columns

comment on column MPS.LOG_EVENT_UPLOAD.id

  is 'ID записи';

comment on column MPS.LOG_EVENT_UPLOAD.ev_ref_id

  is 'Идентификатор запроса хедер, GUID формат';

comment on column MPS.LOG_EVENT_UPLOAD.ev_owner_id

  is 'Система-источник события. Вторичный ключ с таблицей EventOwner';

comment on column MPS.LOG_EVENT_UPLOAD.ev_type_id

  is 'Тип события. Вторичный ключ с таблицей EventType';

comment on column MPS.LOG_EVENT_UPLOAD.ev_external_id

  is 'ID события в системе-источнике события';

comment on column MPS.LOG_EVENT_UPLOAD.client_phone

  is 'Номер телефона клиента';

comment on column MPS.LOG_EVENT_UPLOAD.argumemnts_json

  is 'Аргументы сообщения в формате JSON';

comment on column MPS.LOG_EVENT_UPLOAD.snd_system_id

  is 'Система-отправитель события. Вторичный ключ с таблицей SenderSystem';

comment on column MPS.LOG_EVENT_UPLOAD.status_id

  is 'Статус обработки события. Вторичный ключ с таблицей EventUploadStatus';

comment on column MPS.LOG_EVENT_UPLOAD.date_created

  is 'Дата и время добавления записи';

comment on column MPS.LOG_EVENT_UPLOAD.date_updated

  is 'Дата и время последнего обновления записи';

comment on column MPS.LOG_EVENT_UPLOAD.error_code

  is 'Код ошибки';

comment on column MPS.LOG_EVENT_UPLOAD.error_descriptor

  is 'Описание ошибки';

comment on column MPS.LOG_EVENT_UPLOAD.status_upload_id

  is '0- по умолчанию;1- успех; -1 - данные некорректны ';

comment on column MPS.LOG_EVENT_UPLOAD.clid

  is 'ID клиента';

comment on column MPS.LOG_EVENT_UPLOAD.contrid

  is 'ID договора';

comment on column MPS.LOG_EVENT_UPLOAD.batchid

  is 'ID  сессии  ODI';

-- Create/Recreate primary, unique and foreign key constraints

alter table MPS.LOG_EVENT_UPLOAD

  add constraint PK_LOG_EVENT_UPLOAD primary key (ID)

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