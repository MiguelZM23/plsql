--TOO_MANY_ROWS: Excepción predefinida cuando se obtiene más de una fila
--en un select.
--TOO_MANY_ROWS: Predefined exception when getting more than one row
--in a select.

DECLARE
    l_name departments.dept_name%TYPE;
BEGIN
    SELECT dept_name
        INTO l_name
        FROM departments;
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        dbms_output.put_line('System error. Please Contact Application Support');
        dbms_output.put_line('SQLCODE: '||SQLCODE );
        dbms_output.put_line('SQLERR: '||SQLERRM);
END;