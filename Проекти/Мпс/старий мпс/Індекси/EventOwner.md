```
-- add/modify columns

declare

  type t1 is varray(5) of varchar2(100 char);

  type objects_array_type is varray(145) of t1;

  io objects_array_type := objects_array_type

        ( t1('UNIQUE','IDX_UK_EVENT_OWNER',     'MPS','EVENT_OWNER      (SRC_NAME)   ','MPS_DATA') );

  i integer;

  is_exists varchar2(10 char);

  l_msgsqlerrm varchar2(500);

begin

  for i in 1..io.count

    loop

      select

        case

          when exists ( select 1 from all_indexes a where a.owner = io(i)(3) and a.index_name = io(i)(2) ) then 'Y'

          else 'N'

        end into is_exists

      from dual;

      if (is_exists='N')

        then

          execute immediate 'create '||io(i)(1)||' index '||io(i)(3)||'.'||io(i)(2)||' on '||io(i)(3)||'.'||io(i)(4)||' tablespace '||io(i)(5)||'';  

          dbms_output.put_line('index '||io(i)(2)||' created');

        else

          dbms_output.put_line('index '||io(i)(2)||' already exists');

        end if;

    end loop;      

end;

/
```