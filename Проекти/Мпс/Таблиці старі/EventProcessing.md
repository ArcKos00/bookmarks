-- Create table

create table MPS.EVENT_PROCESSING

(

  id                NUMBER not null,

  ev_ref_id         RAW(16) default sys_guid() not null,

  ev_upl_id         NUMBER not null,

  ev_hand_id        NUMBER,

  ev_proc_status_id NUMBER default 1 not null,

  cnt_try           NUMBER default 0 not null,

  date_created      DATE default sysdate not null,

  date_updated      DATE,

  error_code        NUMBER,

  error_descriptor  VARCHAR2(4000),

  last_proces_date  DATE

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

comment on table MPS.EVENT_PROCESSING

  is 'SMS module(Оперативная таблица для процессирования событий (общая))';

-- Add comments to the columns

comment on column MPS.EVENT_PROCESSING.id

  is 'ID записи';

comment on column MPS.EVENT_PROCESSING.ev_ref_id

  is 'Идентификатор запроса (хедер), GUID формат ';

comment on column MPS.EVENT_PROCESSING.ev_upl_id

  is 'ID записи в таблице EventUpload (FK)';

comment on column MPS.EVENT_PROCESSING.ev_hand_id

  is 'Обработчик события. Вторичный ключ с таблицей EventHandler';

comment on column MPS.EVENT_PROCESSING.ev_proc_status_id

  is 'Статус процессирования события. Вторичный ключ с таблицей EventProcessingStatus';

comment on column MPS.EVENT_PROCESSING.cnt_try

  is 'Количество попыток обработки события';

comment on column MPS.EVENT_PROCESSING.date_created

  is 'Дата и время добавления записи';

comment on column MPS.EVENT_PROCESSING.date_updated

  is 'Дата и время последнего обновления записи';

comment on column MPS.EVENT_PROCESSING.error_code

  is 'Код ошибки';

comment on column MPS.EVENT_PROCESSING.error_descriptor

  is 'Описание ошибки';

comment on column MPS.EVENT_PROCESSING.last_proces_date

  is 'Дата и время последней обработки события';

-- Create/Recreate primary, unique and foreign key constraints

alter table MPS.EVENT_PROCESSING

  add constraint PK_EVENT_PROCESSING primary key (ID)

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

alter table MPS.EVENT_PROCESSING

  add constraint FK_EVENT_PROCESSING_STATUS foreign key (EV_PROC_STATUS_ID)

  references MPS.EVENT_PROCESS_STATUS (ID)

  disable

  novalidate;

alter table MPS.EVENT_PROCESSING

  add constraint FK_EVENT_PROC_HND foreign key (EV_HAND_ID)

  references MPS.EVENT_HANDLER (ID);