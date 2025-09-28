id                     NUMBER not null,

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

  business_line          VARCHAR2(100),

  message_type           VARCHAR2(100),

  is_delivery_guaranteed NUMBER