--Excepción interna de ORACLE nombrada para capturarla específicamente a 
--través del nombre.

--ORACLE inner exception named to catch specifically to
--through the name.

DECLARE
    l_num PLS_INTEGER;
    too_big EXCEPTION;
    PRAGMA EXCEPTION_INIT (too_big, -1426);
BEGIN
    l_num := 2147483648;
EXCEPTION
    WHEN too_big THEN
        dbms_output.put_line('System error. Please Contact Application Support');
        dbms_output.put_line('SQLCODE: '||SQLCODE );
        dbms_output.put_line('SQLERR: '||SQLERRM);
END;