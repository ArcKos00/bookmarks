```
-- Create table

create table MPS.SMS_LOG_ERRORS

(

  id           NUMBER,

  workdate     DATE,

  errorcode    NUMBER,

  errormessage VARCHAR2(4000),

  name_pkg     VARCHAR2(4000),

  name_proc    VARCHAR2(4000),

  id_sess      NUMBER

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

comment on table MPS.SMS_LOG_ERRORS

  is 'Словарь стандартных сообщений';

-- Add comments to the columns

comment on column MPS.SMS_LOG_ERRORS.id

  is 'Идентификатор ';

comment on column MPS.SMS_LOG_ERRORS.workdate

  is 'Рабочая дата';

comment on column MPS.SMS_LOG_ERRORS.errorcode

  is 'Номер сообщения';

comment on column MPS.SMS_LOG_ERRORS.errormessage

  is 'Текст сообщения';
```