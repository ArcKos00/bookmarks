```
-- Create table

create table MPS.EVENT_PROCESS_REQUEST

(

  id                    NUMBER not null,

  ev_ref_id             RAW(16) default sys_guid() not null,

  ev_proc_id            NUMBER not null,

  ev_proc_req_status_id NUMBER default 1 not null,

  date_created          DATE default sysdate not null,

  date_updated          DATE,

  error_code            NUMBER,

  error_descriptor      VARCHAR2(4000),

  snd_temp_vers         VARCHAR2(36),

  snd_mess_body         VARCHAR2(4000),

  date_sended           DATE,

  date_snd_lastsync     DATE,

  external_id           VARCHAR2(36)

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

comment on table MPS.EVENT_PROCESS_REQUEST

  is 'SMS module(Оперативная таблица для процессирования событий (фиксация каждой попытки обработки события))';

-- Add comments to the columns

comment on column MPS.EVENT_PROCESS_REQUEST.id

  is 'ID записи';

comment on column MPS.EVENT_PROCESS_REQUEST.ev_ref_id

  is 'Идентификатор запроса (хедер), GUID формат';

comment on column MPS.EVENT_PROCESS_REQUEST.ev_proc_id

  is 'ID записи в таблице EventProcessing';

comment on column MPS.EVENT_PROCESS_REQUEST.ev_proc_req_status_id

  is 'Статус процессирования события. Вторичный ключ с таблицей EventProcessingRequestStatus';

comment on column MPS.EVENT_PROCESS_REQUEST.date_created

  is 'Дата и время добавления записи';

comment on column MPS.EVENT_PROCESS_REQUEST.date_updated

  is 'Дата и время последнего обновления записи';

comment on column MPS.EVENT_PROCESS_REQUEST.error_code

  is 'Код ошибки';

comment on column MPS.EVENT_PROCESS_REQUEST.error_descriptor

  is 'Описание ошибки';

comment on column MPS.EVENT_PROCESS_REQUEST.snd_temp_vers

  is 'Версия шаблона отправленного сообщения';

comment on column MPS.EVENT_PROCESS_REQUEST.snd_mess_body

  is 'Тело отправленного сообщения';

comment on column MPS.EVENT_PROCESS_REQUEST.date_sended

  is 'Дата и время отправки сообщения';

comment on column MPS.EVENT_PROCESS_REQUEST.date_snd_lastsync

  is 'Дата и время последней попытки синхронизации статусов отправки';

comment on column MPS.EVENT_PROCESS_REQUEST.external_id

  is 'ID сообщения в системе-брокере';

-- Create/Recreate primary, unique and foreign key constraints

alter table MPS.EVENT_PROCESS_REQUEST

  add constraint PK_EVENT_PROCESS_REQUEST primary key (ID)

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

alter table MPS.EVENT_PROCESS_REQUEST

  add constraint FK_EVENT_PROCESSING foreign key (EV_PROC_ID)

  references MPS.EVENT_PROCESSING (ID);

alter table MPS.EVENT_PROCESS_REQUEST

  add constraint FK_EVENT_PROCESS_STATUS_REQ foreign key (EV_PROC_REQ_STATUS_ID)

  references MPS.EVENT_PROCESS_STATUS_REQ (ID);**-- Create table

create table MPS.EVENT_PROCESS_REQUEST

(

  id                    NUMBER not null,

  ev_ref_id             RAW(16) default sys_guid() not null,

  ev_proc_id            NUMBER not null,

  ev_proc_req_status_id NUMBER default 1 not null,

  date_created          DATE default sysdate not null,

  date_updated          DATE,

  error_code            NUMBER,

  error_descriptor      VARCHAR2(4000),

  snd_temp_vers         VARCHAR2(36),

  snd_mess_body         VARCHAR2(4000),

  date_sended           DATE,

  date_snd_lastsync     DATE,

  external_id           VARCHAR2(36)

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

comment on table MPS.EVENT_PROCESS_REQUEST

  is 'SMS module(Оперативная таблица для процессирования событий (фиксация каждой попытки обработки события))';

-- Add comments to the columns

comment on column MPS.EVENT_PROCESS_REQUEST.id

  is 'ID записи';

comment on column MPS.EVENT_PROCESS_REQUEST.ev_ref_id

  is 'Идентификатор запроса (хедер), GUID формат';

comment on column MPS.EVENT_PROCESS_REQUEST.ev_proc_id

  is 'ID записи в таблице EventProcessing';

comment on column MPS.EVENT_PROCESS_REQUEST.ev_proc_req_status_id

  is 'Статус процессирования события. Вторичный ключ с таблицей EventProcessingRequestStatus';

comment on column MPS.EVENT_PROCESS_REQUEST.date_created

  is 'Дата и время добавления записи';

comment on column MPS.EVENT_PROCESS_REQUEST.date_updated

  is 'Дата и время последнего обновления записи';

comment on column MPS.EVENT_PROCESS_REQUEST.error_code

  is 'Код ошибки';

comment on column MPS.EVENT_PROCESS_REQUEST.error_descriptor

  is 'Описание ошибки';

comment on column MPS.EVENT_PROCESS_REQUEST.snd_temp_vers

  is 'Версия шаблона отправленного сообщения';

comment on column MPS.EVENT_PROCESS_REQUEST.snd_mess_body

  is 'Тело отправленного сообщения';

comment on column MPS.EVENT_PROCESS_REQUEST.date_sended

  is 'Дата и время отправки сообщения';

comment on column MPS.EVENT_PROCESS_REQUEST.date_snd_lastsync

  is 'Дата и время последней попытки синхронизации статусов отправки';

comment on column MPS.EVENT_PROCESS_REQUEST.external_id

  is 'ID сообщения в системе-брокере';

-- Create/Recreate primary, unique and foreign key constraints

alter table MPS.EVENT_PROCESS_REQUEST

  add constraint PK_EVENT_PROCESS_REQUEST primary key (ID)

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

alter table MPS.EVENT_PROCESS_REQUEST

  add constraint FK_EVENT_PROCESSING foreign key (EV_PROC_ID)

  references MPS.EVENT_PROCESSING (ID);

alter table MPS.EVENT_PROCESS_REQUEST

  add constraint FK_EVENT_PROCESS_STATUS_REQ foreign key (EV_PROC_REQ_STATUS_ID)

  references MPS.EVENT_PROCESS_STATUS_REQ (ID);**
```