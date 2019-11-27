SELECT *
FROM no_emp;

--1. leaf node ã��
--
SELECT LPAD(' ', (LEVEL-1)*4,' ') || org_cd, s_emp
FROM
    (SELECT org_cd, parent_org_cd, SUM(s_emp) s_emp
    FROM
    (SELECT org_cd, parent_org_cd,
           SUM(no_emp/org_cnt) OVER (PARTITION by gr ORDER BY rn
                             ROWS BETWEEN UNBOUNDED PRECEDING  AND CURRENT ROW) s_emp 
    FROM
        (SELECT a.*, ROWNUM rn, a.lv + ROWNUM gr,
                COUNT(org_cd) OVER(PARTITION BY org_cd) org_cnt
        FROM 
            (SELECT org_cd, parent_org_cd, no_emp, LEVEL LV, connect_by_isleaf leaf
            FROM no_emp
            START WITH parent_org_cd IS NULL
            CONNECT BY PRIOR org_cd = parent_org_cd) a
    START WITH leaf = 1
    CONNECT BY PRIOR parent_org_cd = org_cd))
    GROUP BY org_cd, parent_org_cd)
START WITH parent_org_cd IS NULL
CONNECT BY PRIOR org_cd = parent_org_cd;

--PL/SQL
--�Ҵ翬�� :=
-- System.out,println("") --> dbms_out.put_line("");
--log4j
--set serveroutput on; --��±���� Ȱ��ȭ

set serveroutput on;

--PL/SQL
--declare : ����, ��� ����
--begin : ���� ����
--exception : ����ó��
DESC dept;
set serveroutput on;
DECLARE
    --���� ����
    deptno NUMBER(2);
    dname VARCHAR2(14);
BEGIN
    SELECT deptno, dname INTO deptno, dname
    FROM dept
    WHERE deptno = 10;
    
    --SELECT ���� ����� ������ �� �Ҵ� �ߴ��� Ȯ��
    DBMS_OUTPUT.PUT_LINE('dname : ' || dname || '(' || deptno || ')');
END;
/

--
DECLARE
    --���� ���� ����(���̺� �÷�Ÿ���� ����ǵ� pl/sql ������ ������ �ʿ䰡 ����)
    deptno dept.deptno%TYPE;
    dname dept.dname%TYPE;
BEGIN
    SELECT deptno, dname INTO deptno, dname
    FROM dept
    WHERE deptno = 10;
    
    --SELECT ���� ����� ������ �� �Ҵ� �ߴ��� Ȯ��
    DBMS_OUTPUT.PUT_LINE('dname : ' || dname || '(' || deptno || ')');
END;
/


--10�� �μ��� �μ��̸��� LOC������ ȭ�鿡 ����ϴ� ���ν���
--���ν����� : printdept
-- CREATE OR REPLACE VIEW
CREATE OR REPLACE PROCEDURE prindept
IS
    --��������
    dname dept.dname%TYPE;
    loc dept.loc%TYPE;
BEGIN
    SELECT dname, loc
    INTO dname, loc
    FROM dept
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE('dname, loc = ' || dname || ',' || loc);
END;
/ 
exec printdept;


CREATE OR REPLACE PROCEDURE prindept_p(p_deptno IN dept.deptno%TYPE)
IS
    --��������
    dname dept.dname%TYPE;
    loc dept.loc%TYPE;
BEGIN
    SELECT dname, loc
    INTO dname, loc
    FROM dept
    WHERE deptno = p_deptno;
    
    DBMS_OUTPUT.PUT_LINE('dname, loc = ' || dname || ',' || loc);
END;
/ 
exec printdept;

-- �ǽ� PRO_1
-- procedure : printemp
-- �Է� : �����ȣ
-- ��� : ����̸�, �μ��̸�

CREATE OR REPLACE PROCEDURE printemp(p_empno IN emp.empno%TYPE)
IS
    --��������
    ename emp.ename%TYPE;
    dname dept.dname%TYPE;
BEGIN
    SELECT a.ename, b.dname INTO ename, dname
    FROM emp a, dept b
    WHERE a.deptno = b.deptno
    AND empno = p_empno;

    DBMS_OUTPUT.PUT_LINE('ename, dname = ' || ename || ',' || dname);
END;
/
exec printemp(7788);

select *
FROM dept_test;
delete dept_test
where deptno >90;
drop table dept_test;
create table dept_test as
select *
from dept;

-- �ǽ� PRO_2
CREATE OR REPLACE PROCEDURE registdept_test (p_deptno IN dept.deptno%TYPE,
                                             p_dname IN dept.dname%TYPE,
                                             p_loc IN dept.loc%TYPE)
IS
    
BEGIN
    INSERT INTO dept_test VALUES (p_deptno, p_dname, p_loc);
END;
/
exec registdept_test(50, 'test', 'seoul'); --Ÿ�Ե� ���缭 �־����.
select *
from dept_test;