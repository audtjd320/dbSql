SELECT *
FROM no_emp;

--1. leaf node 찾기
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
--할당연산 :=
-- System.out,println("") --> dbms_out.put_line("");
--log4j
--set serveroutput on; --출력기능을 활성화

set serveroutput on;

--PL/SQL
--declare : 변수, 상수 선언
--begin : 로직 실행
--exception : 예외처리
DESC dept;
set serveroutput on;
DECLARE
    --변수 선언
    deptno NUMBER(2);
    dname VARCHAR2(14);
BEGIN
    SELECT deptno, dname INTO deptno, dname
    FROM dept
    WHERE deptno = 10;
    
    --SELECT 절의 결과를 변수에 잘 할당 했는지 확인
    DBMS_OUTPUT.PUT_LINE('dname : ' || dname || '(' || deptno || ')');
END;
/

--
DECLARE
    --참조 변수 선언(테이블 컬럼타입이 변경되도 pl/sql 구문을 수정할 필요가 없다)
    deptno dept.deptno%TYPE;
    dname dept.dname%TYPE;
BEGIN
    SELECT deptno, dname INTO deptno, dname
    FROM dept
    WHERE deptno = 10;
    
    --SELECT 절의 결과를 변수에 잘 할당 했는지 확인
    DBMS_OUTPUT.PUT_LINE('dname : ' || dname || '(' || deptno || ')');
END;
/


--10번 부서의 부서이름과 LOC정보를 화면에 출력하는 프로시저
--프로시저명 : printdept
-- CREATE OR REPLACE VIEW
CREATE OR REPLACE PROCEDURE prindept
IS
    --변수선언
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
    --변수선언
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

-- 실습 PRO_1
-- procedure : printemp
-- 입력 : 사원번호
-- 출력 : 사원이름, 부서이름

CREATE OR REPLACE PROCEDURE printemp(p_empno IN emp.empno%TYPE)
IS
    --변수선언
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

-- 실습 PRO_2
CREATE OR REPLACE PROCEDURE registdept_test (p_deptno IN dept.deptno%TYPE,
                                             p_dname IN dept.dname%TYPE,
                                             p_loc IN dept.loc%TYPE)
IS
    
BEGIN
    INSERT INTO dept_test VALUES (p_deptno, p_dname, p_loc);
END;
/
exec registdept_test(50, 'test', 'seoul'); --타입도 맞춰서 넣어야함.
select *
from dept_test;