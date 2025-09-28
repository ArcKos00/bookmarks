```
CREATE OR REPLACE PACKAGE MPS.pkg_sms_module_log IS

  -- Author  : LUKIANENKOVO
  -- Created : 27.08.2021 11:11:10
  -- Purpose : SMS module 
  PROCEDURE p_log_ins(p_ercode NUMBER,
                      p_ermsg  VARCHAR2,
                      p_module VARCHAR2,
                      p_proc   VARCHAR2,
                      p_idsess NUMBER DEFAULT USERENV ('sessionid'));
END pkg_sms_module_log;
/
CREATE OR REPLACE PACKAGE BODY MPS.pkg_sms_module_log IS

  PROCEDURE p_log_ins(p_ercode NUMBER,
                      p_ermsg  VARCHAR2,
                      p_module VARCHAR2,
                      p_proc   VARCHAR2,
                      p_idsess NUMBER DEFAULT USERENV ('sessionid')) IS
    l_sqlerrm VARCHAR2(1000);
  BEGIN
    INSERT INTO MPS.sms_log_errors
      (id, workdate, errorcode, errormessage, name_pkg, name_proc, id_sess)
    
    VALUES
      (MPS.seq_sms_log_errors.nextval,
       SYSDATE,
       p_ercode,
       p_ermsg,
       p_module,
       p_proc,
       p_idsess);
    COMMIT;
  
  EXCEPTION
    WHEN OTHERS THEN
      l_sqlerrm := dbms_utility.format_error_stack ||
                   dbms_utility.format_error_backtrace;
    
      INSERT INTO MPS.sms_log_errors
        (id,
         workdate,
         errorcode,
         errormessage,
         name_pkg,
         name_proc,
         id_sess)
      VALUES
        (MPS.seq_sms_log_errors.nextval,
         SYSDATE,
         'MPS.pkg_sms_module',
         l_sqlerrm,
         p_module,
         p_proc,
         p_idsess);
      COMMIT;
  END;

BEGIN
  NULL;
END pkg_sms_module_log;
/

```