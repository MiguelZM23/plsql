DECLARE
    TYPE rc_weak IS REF CURSOR;
    rc_weak_cur rc_weak;
    l_dept_rowtype departments%ROWTYPE;
    l_emp_rowtype employee%ROWTYPE;
    
BEGIN
    OPEN rc_weak_cur FOR
        SELECT * FROM departments 
                WHERE dept_id = 1;
    LOOP
        FETCH rc_weak_cur INTO l_dept_rowtype;
        EXIT WHEN rc_weak_cur%NOTFOUND;
        dbms_output.put_line(l_dept_rowtype.dept_name);
    END LOOP;
    dbms_output.put_line('Now Running the ref cursor for the employee query');
    OPEN rc_weak_cur FOR
        SELECT * FROM employee 
                WHERE emp_dept_id = 2;
    LOOP
        FETCH rc_weak_cur INTO l_emp_rowtype;
        EXIT WHEN rc_weak_cur%NOTFOUND;
        dbms_output.put_line(l_emp_rowtype.emp_id);
    END LOOP;
    CLOSE rc_weak_cur;
        
END;
