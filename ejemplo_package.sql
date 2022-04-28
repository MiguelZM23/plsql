CREATE OR REPLACE PACKAGE hr_mgmt AS


   g_active_status  CONSTANT  VARCHAR2(1)  := 'A';
   g_inactive_status CONSTANT VARCHAR2(1)  := 'I';
   g_bonus_pct NUMBER := 0;


   dept_not_found_ex EXCEPTION;


   TYPE g_rec IS RECORD(p_profit NUMBER, p_dept_name departments.dept_name%TYPE);


   CURSOR gcur_get_deptid(p_dept_name VARCHAR2) IS
     SELECT dept_id
       FROM departments
      WHERE dept_name = p_dept_name; 


   FUNCTION  calc_bonus(p_profit NUMBER, p_dept_id NUMBER) RETURN NUMBER;
   FUNCTION  calc_bonus(p_profit NUMBER, p_dept_name VARCHAR2) RETURN NUMBER;
   FUNCTION  calc_bonus(p_rec g_rec) RETURN NUMBER;
   PROCEDURE update_emp(p_emp_id NUMBER, p_dept_name VARCHAR2);


END hr_mgmt;
/

CREATE OR REPLACE PACKAGE BODY hr_mgmt AS
    emp_status VARCHAR2(1);
    CURSOR cur_get_sal(p_dept_id NUMBER ) IS
     SELECT SUM(emp_sal)
       FROM employee
      WHERE emp_dept_id = p_dept_id
       AND  emp_status = g_active_status;
   PROCEDURE  set_bonus(p_profit NUMBER) IS
     BEGIN
       DBMS_OUTPUT.PUT_LINE('Inside set_bonus ');
       g_bonus_pct := 0;
       IF p_profit < 100000 THEN
         g_bonus_pct := 1;
       ELSE
         g_bonus_pct := 2;
       END IF;
   END set_bonus;
   FUNCTION   get_bonus(p_dept_id NUMBER) RETURN NUMBER IS
     l_sal NUMBER;
     BEGIN
       DBMS_OUTPUT.PUT_LINE('Inside get_bonus ');
       OPEN cur_get_sal(p_dept_id);
       FETCH cur_get_sal INTO l_sal;
       CLOSE cur_get_sal;
       RETURN l_sal * g_bonus_pct;
   END get_bonus;
  FUNCTION  calc_bonus(p_profit NUMBER, p_dept_id NUMBER) RETURN NUMBER IS
   BEGIN
     set_bonus(p_profit);
     return get_bonus(p_dept_id);
   EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM ||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RAISE;
   END calc_bonus;
  FUNCTION  calc_bonus(p_profit NUMBER, p_dept_name VARCHAR2) RETURN NUMBER IS
     l_dept_id departments.dept_id%TYPE;   
  BEGIN
     OPEN gcur_get_deptid(p_dept_name ) ;
     FETCH gcur_get_deptid INTO l_dept_id;
     CLOSE gcur_get_deptid;
     RETURN calc_bonus(p_profit,l_dept_id);
  END calc_bonus;
  FUNCTION  calc_bonus(p_rec g_rec) RETURN NUMBER IS
   BEGIN
     return calc_bonus(p_rec.p_profit,  p_rec.p_dept_name);
   END calc_bonus;
  PROCEDURE update_emp(p_emp_id NUMBER, p_dept_name VARCHAR2) IS
     l_dept_id departments.dept_id%TYPE;
   BEGIN
     DBMS_OUTPUT.PUT_LINE('Inside update_emp ');
     OPEN gcur_get_deptid(p_dept_name);
     FETCH gcur_get_deptid INTO l_dept_id;
     CLOSE gcur_get_deptid;
     IF l_dept_id IS NULL THEN
       RAISE dept_not_found_ex;
     END IF;
     UPDATE employee
        SET emp_dept_id = l_dept_id  WHERE emp_id = p_emp_id;
     DBMS_OUTPUT.PUT_LINE('Updated  Rows: '||SQL%ROWCOUNT);
     COMMIT;
   EXCEPTION
    WHEN dept_not_found_ex THEN
      DBMS_OUTPUT.PUT_LINE('Invalid dept name '||p_dept_name);
      RAISE;    
   END update_emp; 
BEGIN
    g_bonus_pct:= 0;
EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_STACK);
      DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
       RAISE; 
END hr_mgmt;