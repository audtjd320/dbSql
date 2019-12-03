--�͸� ���
SET serveroutput on;

DECLARE
    -- ����̸��� ������ ��Į�� ����(1���� ��)
    v_ename emp.ename%TYPE;
BEGIN
    SELECT ename
    INTO v_ename
    FROM emp;
    --��ȸ����� �������ε� ��Į�󺯼��� ���� �����Ϸ��� �Ѵ� --> ����
    
    --�߻�����, �߻����ܸ� Ư�� ���� ���鶧 --> OTHER (java : Exception)
    EXCEPTION
        WHEN others THEN
            dbms_output.put_line('Exception others');
END;
/


--����� ���� ����
DECLARE
    --emp ���̺� ��ȸ�� ����� ���� ��� �߻���ų ����� ���� ����
    --���ܸ� EXCEPTION;        --������ ����Ÿ���� ���¿� ����
    NO_EMP EXCEPTION;
    v_ename emp.ename%TYPE;
BEGIN
    BEGIN
        SELECT ename
        INTO v_ename
        FROM emp
        WHERE empno=9999;
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                dbms_output.put_line('������ ������');
                --����ڰ� ������ ����� ���� ���ܸ� ����
                RAISE NO_EMP;
    END;
    
    EXCEPTION
        WHEN NO_EMP THEN
            dbms_output.put_line('no_emp exception');
END;
/

--�����ȣ�� �����ϰ�, �ش� �����ȣ�� �ش��ϴ� ����̸��� �����ϴ� �Լ�(function)
CREATE OR REPLACE FUNCTION getEmpName(p_empno emp.empno%TYPE)
RETURN VARCHAR2
IS
     --�����
     ret_ename emp.ename%TYPE;
BEGIN
    --����    
    SELECT ename
    INTO ret_ename
    FROM emp
    WHERE empno = p_empno;
    
    RETURN ret_ename;
END;
/

select getEmpName(7369)
FROM dual;

select empno, ename, getEMPNAME(empno)
FROM emp;

--�ǽ� function1
CREATE OR REPLACE FUNCTION getdeptname(p_deptno dept.deptno%TYPE)
RETURN VARCHAR2
IS
     --�����
     ret_dname dept.dname%TYPE;
BEGIN
    --����    
    SELECT dname
    INTO ret_dname
    FROM dept
    WHERE deptno = p_deptno;
    
    RETURN ret_dname;
END;
/
select getdeptname(99)
from dual;

select deptno
from dept;

SELECT empno, ename, deptno  , getdeptname(deptno),
       (SELECT dname FROM dept WHERE dept.deptno = emp.deptno) dname
FROM emp;

--�ǽ� function2
CREATE OR REPLACE FUNCTION indent(p_level NUMBER, p_dname dept.dname%TYPE) RETURN VARCHAR2
IS
    ret_text VARCHAR2(50);
BEGIN
    SELECT LPAD(' ', (p_level -1)*4, ' ') || p_dname
    INTO ret_text
    FROM dual;
    
    RETURN ret_text;
END;
/

select indent(2, 'ACCOUNTING')
FROM dual;



--������ ���
--SELECT deptcd, indent() as deptnm
select deptcd , indent(level, deptnm) as deptnm
--SELECT deptcd, LPAD(' ',(level-1)*4,' ') || deptnm as deptnm
FROM dept_h
START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;
---------------------------------
  
select deptcd, deptnm, p_deptcd, level
from dept_h
START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;

select *
FROM dept_h;


CREATE TABLE user_history(
    userid VARCHAR2(20),
    pass VARCHAR2(100),
    mod_dt DATE
);

--users 3���̺��� pass �÷��� ����� ���
--users_history�� ������ pass�� �̷����� ����� Ʈ����
CREATE OR REPLACE TRIGGER make_history
    BEFORE UPDATE ON users -- users���̺��� ������Ʈ ����
    FOR EACH ROW
    
    BEGIN
        -- :NEW.�÷��� : UPDATE ������ �ۼ��� ��
        --,:OLD.�÷��� : ���� ���̺� ��
        IF :NEW.pass != :OLD.pass THEN
            INSERT INTO user_history
            VALUES (:OLD.userid, :Old.pass, sysdate);
        END IF;
    END;
    /
    
    
select *
FROM users;

update users SET pass = 'brownpass'
WHERE userid = 'brown';

select *
FROM user_history;





