--Para evitar que cuando haya una excepción salte toda la pila de errores,
--podemos capturar la excepción para mostrar la información necesaria y un 
--aviso de que contacte con soporte.
--To avoid that when there is an exception the whole stack of errors jumps,
--we can catch the exception to display the necessary information and a
--Notice to contact support.

DECLARE
    l_name departments.dept_name%TYPE;
BEGIN
    SELECT dept_name
        INTO l_name
        FROM departments
    WHERE dept_id = 10;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('System error. Please Contact Application Support');
        dbms_output.put_line('SQLCODE: '||SQLCODE );
        dbms_output.put_line('SQLERR: '||SQLERRM);
END;