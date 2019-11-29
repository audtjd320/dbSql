-- �ǽ� PRO_2
CREATE OR REPLACE PROCEDURE registdept_test (p_deptno IN dept.deptno%TYPE,
                                             p_dname IN dept.dname%TYPE,
                                             p_loc IN dept.loc%TYPE)
IS
    
BEGIN
    INSERT INTO dept_test VALUES (p_deptno, p_dname, p_loc);
END;
/
exec registdept_test(60, 'test', 'seoul'); --Ÿ�Ե� ���缭 �־����.

select *
from dept_test;

--�ǽ� PRO_3
CREATE OR REPLACE PROCEDURE UPDATEdept_test (p_deptno IN dept.deptno%TYPE,
                                             p_dname IN dept.dname%TYPE,
                                             p_loc IN dept.loc%TYPE)
IS

BEGIN
    UPDATE dept_test SET dname = p_dname, loc = p_loc
    WHERE deptno = p_deptno;
    commit;
END;
/
exec UPDATEdept_test(99, 'ddit_m', 'daejeon');

SELECT *
FROM dept_test;

----------------------------
--ROWTYPE : ���̺��� �� ���� �����͸� ���� �� �ִ� ���� Ÿ��
set serveroutput on;
DECLARE
    dept_row dept%ROWTYPE;
BEGIN
    SELECT *
    INTO dept_row
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_line(dept_row.deptno || ', ' || dept_row.dname || ', ' || dept_row.loc);
END;
/

--���պ��� : record
DECLARE
    --UserVo userVo;
    TYPE dept_row IS RECORD(  --dept_row��� �����Ÿ�� ����, ���࿡ �ΰ��� �÷�
        deptno NUMBER(2),
        dname dept.dname%TYPE);
    
    v_dname dept.dname%TYPE;    
    v_row dept_row;      -- ������ Ÿ��
BEGIN
    SELECT deptno, dname
    INTO v_row
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_line( v_row.deptno || ', ' || v_row.dname);
END;
/

--tabletype
DECLARE
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    
    --java : Ÿ�� ������;
    --pl/sql : ������ Ÿ��;
    v_dept dept_tab; 
    bi BINARY_INTEGER;
BEGIN
    bi := 100;

    SELECT *
    BULK COLLECT INTO v_dept
    FROM dept;
    
    DBMS_OUTPUT.PUT_LINE(bi);
    -- list.size() ==> ���̺��.count (����??)
    FOR i IN 1..v_dept.count LOOP
    DBMS_OUTPUT.PUT_LINE(v_dept(i).dname); -- �ε��� 1���� ����
    END LOOP;
END;
/

--IF
--  ELSE IF --> ELSIF
-- END IF;
DECLARE
    ind BINARY_INTEGER; --BINARY_INTEGER : �ε����� Ÿ��
BEGIN
    ind := 2; --���Կ�����
    
    IF ind = 1 THEN
        dbms_output.put_line(ind);
    ELSIF ind = 2 THEN
        dbms_output.put_line('ELSIF ' || ind);
    ELSE 
        dbms_output.put_line('ELSE');
    END IF;
END;
/

--FOR LOOP :
--FOR �ε��� ���� IN ���۰�..���ᰪ LOOP
--END LOOP;

DECLARE
BEGIN
    FOR i IN 0..5 LOOP
        DBMS_OUTPUT.PUT_LINE('i : ' || i);
    END LOOP;
END;
/


--LOOP : ��� ���� �Ǵ� ������ LOOP �ȿ��� ����
--java : while(true)

DECLARE
    i NUMBER;
BEGIN
    i := 0;
    
    LOOP
        DBMS_OUTPUT.PUT_LINE(i);
        i := i + 1;
        -- LOOP ��� ���࿩�� �Ǵ� (����)
        EXIT WHEN i >=5;
    END LOOP;
END;
/

 CREATE TABLE DT
(	DT DATE);

insert into dt
select trunc(sysdate + 10) from dual union all
select trunc(sysdate + 5) from dual union all
select trunc(sysdate) from dual union all
select trunc(sysdate - 5) from dual union all
select trunc(sysdate - 10) from dual union all
select trunc(sysdate - 15) from dual union all
select trunc(sysdate - 20) from dual union all
select trunc(sysdate - 25) from dual;

commit;

--�ǽ� PRO_3
--dt���̺��� dt(��¥
-- ���� ��� : 5��
DECLARE
    TYPE dt_tab IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;
    
    dtdt dt_tab;
    i NUMBER;
    dt_sum NUMBER;
    --dt_sum NUMBER := 0; -- ���� ����� �ʱ�ȭ ���ð���
BEGIN
    i := 1;
    dt_sum := 0;
    SELECT *
    BULK COLLECT INTO dtdt
    FROM dt
    ORDER BY dt desc ; -- ���� ��ȸ������ ���� �� ������ ������ �ϴ°��� ��õ
    
    
    LOOP
       
        DBMS_OUTPUT.PUT_LINE(dtdt(i).dt-(dtdt(i+1).dt));
        dt_sum := dt_sum + dtdt(i).dt-(dtdt(i+1).dt);
         i := i + 1;
        
         EXIT WHEN i = dtdt.count;
    END LOOP;
         DBMS_OUTPUT.PUT_LINE('���� ��� : ' || dt_sum/(dtdt.count-1) || '��');
END;
/

-- lead, lag �������� ����, ���� �����͸� ������ �� �ִ�.
select AVG(diff)
from
    (SELECT dt, lead(dt) over(order by dt desc),
           dt - lead(dt) over(order by dt desc) diff
     FROM dt
order by dt desc);

--�м��Լ��� ������� ���ϴ� ȯ�濡��
select avg(c)
from
    (select a.dt, a.rn, b.rn, (a.dt-b.dt) c
    from
        (select rownum rn, dt
        from
            (select dt
             from dt
             order by dt desc) a)a,
        (select rownum rn, dt
        from
            (select dt
             from dt
             order by dt desc) b)b
    where a.rn = b.rn(+)-1);

-- HALL OF HONOR
select (max(dt)-MIN(dt))/ (count(*)-1)
from dt;


--cursor
--�������� �����͸� ���̺�Ÿ�� ���� �۾�
DECLARE
    --Ŀ�� ����
    CURSOR dept_cursor IS
        SELECT deptno, dname FROM dept;
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    --Ŀ�� ����
    OPEN dept_cursor;
    LOOP 
        FETCH dept_cursor INTO v_deptno, v_dname;
        dbms_output.put_line(v_deptno || ', ' || v_dname);
        EXIT WHEN dept_cursor%NOTFOUND; -- ���̻� ���� ����Ŀ�� ���� �� ����
    END LOOP;
END;
/

--FOR LOOP CURSOR ����
DECLARE
    CURSOR dept_cursor IS
        SELECT deptno, dname
        FROM dept;
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;    
BEGIN
    FOR rec IN dept_cursor LOOP
        dbms_output.put_line(rec.deptno || ', ' || rec.dname);
    END LOOP;
    
END;
/

--�Ķ���Ͱ� �ִ� ����� Ŀ��
DECLARE
    CURSOR emp_cursor(p_job emp.job%TYPE) IS
        SELECT empno, ename, job
        FROM emp
        WHERE job = p_job;
        
BEGIN
    FOR emp IN emp_cursor('SALESMAN') LOOP
    dbms_output.put_line(emp.empno || ', ' || emp.ename ||', '|| emp.job);
    END LOOP;
END;
/