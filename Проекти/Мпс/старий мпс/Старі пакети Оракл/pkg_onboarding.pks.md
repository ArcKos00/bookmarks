```
create or replace package MPS.PKG_ONBOARDING is

  -- Author  : OSADCHYIV
  -- Created : 23.05.2024 12:49:08
  -- Purpose : 
  
  -- Public type declarations
  --type <TypeName> is <Datatype>;
  
  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  --<VariableName> <Datatype>;

  -- Public function and procedure declarations
  procedure prc_insert_for_onbrdng ( pi_json in varchar2, po_event_upload_id out varchar2, po_error out varchar2 );

end PKG_ONBOARDING;
/
create or replace package body MPS.PKG_ONBOARDING is

  -- Private type declarations
  --type <TypeName> is <Datatype>;
  
  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  --<VariableName> <Datatype>;

  -- Function and procedure implementations
  procedure prc_chk_event_owner_id ( p_owner_nm in varchar2, p_event_owner_id out number, p_error out varchar2 )
    is
    begin
      select id into p_event_owner_id from mps.event_owner where src_name = p_owner_nm;
      exception when no_data_found then p_error := 'Owner not found';
    end;
    
  procedure prc_chk_event_owner_id ( p_sender_system_nm in varchar2, p_sender_system_id out number, p_error out varchar2 )
    is
    begin
      select id into p_sender_system_id from mps.sender_system where snd_sysname = p_sender_system_nm;
      exception when no_data_found then p_error := 'Sender system not found';
    end;
      
  procedure prc_chk_event_owner_id ( p_event_nm in varchar2, p_event_id out varchar2, p_error out varchar2 )
    is
    begin
      select id into p_event_id from mps.event_type where ev_name = p_event_nm;
      exception when no_data_found then p_error := 'Event type not found';
    end;

  procedure prc_insert_for_onbrdng ( pi_json in varchar2, po_event_upload_id out varchar2, po_error out varchar2 )
    as
      v_owner             varchar2(100);
      v_event_name        varchar2(100);
      v_sender_system     varchar2(100);
      v_client_phone      varchar2(20);
      v_owner_id          number;
      v_sender_system_id  number;
      v_event_type_id     number;
      v_upload_id         number;
      v_param_name        varchar2(100);
      v_param_value       varchar2(100);
      v_status_id         number := 1;
    begin
      -- ініціалізація вихідних параметрів
      po_event_upload_id := null;
      po_error := null;
      -- розбір json
      v_owner         := json_value(pi_json, '$.owner');
      v_event_name    := json_value(pi_json, '$.eventName');
      v_sender_system := json_value(pi_json, '$.senderSystem');
      v_client_phone  := json_value(pi_json, '$.phoneNumber');
      -- знайти event_owner.id
      prc_chk_event_owner_id ( p_owner_nm => v_owner, p_event_owner_id => v_owner_id , p_error => po_error ); --in , out , out
      -- знайти sender_system.id
      prc_chk_event_owner_id ( p_sender_system_nm => v_sender_system , p_sender_system_id => v_sender_system_id , p_error => po_error ); --in , out , out
      -- знайти event_type.id
      prc_chk_event_owner_id ( p_event_nm  => v_event_name , p_event_id  => v_event_type_id , p_error => po_error ); --in , out , out
      if po_error is not null then return; end if;
      -- вставити дані у таблицю event_upload
      v_upload_id := mps.seq_event_upload.nextval; 
      insert into mps.event_upload ( id, ev_ref_id, ev_owner_id, ev_type_id, client_phone, snd_system_id, status_id, status_upload_id, date_created ) 
                             values ( v_upload_id, sys_guid(), v_owner_id, v_event_type_id, v_client_phone, v_sender_system_id, v_status_id, 0, sysdate );
      --dbms_output.put_line(' owner: '||v_owner||' , eventName: '||v_event_name||' , senderSystem: '||v_sender_system||' , phoneNumber: '||v_client_phone );
      -- вставити дані у таблицю event_data для кожного параметра
      for i in ( select name, value from json_table( pi_json , '$.parameters[*]' columns ( name varchar2(1000) path '$.name' , value varchar2(1000) path '$.value' ) ) )
        loop
          v_param_name  := i.name;
          v_param_value := i.value;
          --dbms_output.put_line(' parameters: ( name: '||v_param_name||' , value: '||v_param_value||' ) ');
          insert into mps.event_data ( id, ev_upl_id, ev_code, ev_data , status ) 
                               values ( mps.seq_event_upload.nextval, v_upload_id, v_param_name, v_param_value, v_status_id );
        end loop;
      -- оновлення статусу в таблиці event_upload
      update mps.event_upload
        set status_upload_id = 1
        where id = v_upload_id;       
      commit;
      -- встановити значення вихідного параметра
      po_event_upload_id := v_upload_id;
      exception when others then po_error := sqlerrm;
    end;
end PKG_ONBOARDING;
/

```