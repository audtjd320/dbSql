--emp 테이블에 empno컬럼을 기준으로 RPIMARY KEY 생성
--PRIMARY KEY = UNIQUE + NOT NULL;
--UNIQUE ==>해당 컬럼으로 UNIGUE IONDEX를 자동으로 생성

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
ALTER TABLE emp DROP CONSTRAINT E_TEST; -- 제약 삭제
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE (dbms_xplan.display);
-- UNIQUE 제약조건으로 유일하기때문에 조건에 맞는거 하나를 바로 찾음
--|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |

--empno 컬럼으로 인덱스가 존재하는 상황에서
--다른컬럼 값으로 데이터를 조회하는 경우
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);
--TABLE ACCESS FULL 테이블의 값들을 모두 다 읽고 조건에 맞는 것을 찾음
--|*  1 |  TABLE ACCESS FULL| EMP  |     3 |   261 |     3   (0)| 00:00:01 |

--인덱스 생성하는 방법 2가지
--1. UNIQUE 제약
--2. 직접 생성

--인덱스 구성 컬럼만 SELECT 절에 기술한 경우
--테이블에 접근이 필요없다.
EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);



--컬럼에 중복이 가능한 non-unique 인덱스 생성 후
--unique index와의 실행계획 비교
--PRIMARY KEY 제약조건 삭제(unique 인덱스 삭제)
ALTER TABLE emp DROP CONSTRAINT pk_emp;


--유니크 인덱스 생성
CREATE INDEX /*UNIQUE*/ IDX_emp_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE (dbms_xplan.display);
--empno값을 기준으로 non-unique인덱스 생성 => empno값을 기준으로 정렬(기본 오름차순, 옵션을 통해 내림차순도 가능)
--정렬이 되어 있어서 7782를 검색하고 7782와 다른값이 나올때 까지만 검색하고 마침
--|*  2 |   INDEX RANGE SCAN          | IDX_EMP_01 |     1 |       |     1   (0)| 00:00:01 |

--emp 테이블에 job 컬럼으로 두번째 인덱스 생성 (non-unique index)
--job 컬럼은 다른 로우의 job 컬럼과 중복이 가능한 컬럼이다
CREATE INDEX idx_emp_02 ON emp (job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE (dbms_xplan.display);


--WHERE절 조건 추가
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE (dbms_xplan.display);
--MANAGER를 찾은후 그중 C로 시작하는 단어만 빼고 버림

--emp 테이블에 job, ename컬럼을 기준으로 non-unique 인덱스 생성(기준 2개)
CREATE INDEX idx_emp_03 ON emp (job, ename);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE (dbms_xplan.display);
-- job이 'MANAGET'이고 C로 시작하는 부분부터 아닌곳 까지 검색

--emp 테이블에 ename, job 컬럼으로 non-unique 인덱스 생성 (위에거에서 기준 순서 변경)
CREATE INDEX  idx_emp_04 ON emp (ename, job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE '%C';

SELECT *
FROM TABLE (dbms_xplan.display);
-- 인덱스 중 옵티마이저가 생각하는 것을 선택



-- HINT를 사용한 실행계획 제어 => /*+    */ 
-- /*+ */ 이처럼 주석안에+를 붙이면 sql이 사용자가 hint를 준다고 생각함. 문법이 잘못되었을 경우 무시
CREATE INDEX  idx_emp_04 ON emp (ename, job);

EXPLAIN PLAN FOR
SELECT /*+ INDEX (emp idx_emp_04) */ *   
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE '%C';

SELECT *
FROM TABLE (dbms_xplan.display);

--INDEX 실습idx1
/*
    CREATE TABLE DEPT TEST AS SELECT * FROM DEPT WHERE 1 = 1
    구문으로 DEPT_TEST 테이블을 생성후 다음 조건에 맞는 인덱스를 생성하세요.
    */
CREATE TABLE DEPT_TEST AS 
SELECT * FROM DEPT WHERE 1 = 1;

SELECT *
FROM DEPT_TEST;
-- deptno컬럼을 기준으로 unique 인덱스 생성
CREATE UNIQUE INDEX d_idx_test ON dept_test(deptno);
-- dname 컬럼을 기준으로 non-uniuqe 인덱스 생성
CREATE INDEX d_idx_test2 ON dept_test(dname);
-- deptno, dname 컬럼을 기준으로 non-unique 인덱스 생성
CREATE INDEX d_idx_test3 ON dept_test(deptno, dname);

--INDEX 실습idx2
-- 실습 idx1에서 생성한 인덱스를 삭제하는 DDL 문을 작성하세요.
DROP INDEX d_idx_test;
DROP INDEX d_idx_test2;
DROP INDEX d_idx_test3;

--INDEX 실습idx3
/*
    시스템에서 사용하는 쿼리가 다음과 같다고 할 때 적절한 emp 테이블에
    필요하다고 생각되는 인덱스를 생성 스크립트를 만들어 보세요.
    */
EXPLAIN PLAN FOR
SELECT *
FROM EMP
WHERE empno =7298;

DROP INDEX idx_emp_01;
CREATE UNIQUE INDEX idx_emp_05 ON emp (empno);
-------------------
EXPLAIN PLAN FOR
SELECT *
FROM EMP
WHERE ename = 'SCOTT';
CREATE UNIQUE INDEX idx_emp_06 ON emp (ename ,empno);
---------------------
EXPLAIN PLAN FOR
SELECT *
FROM EMP
WHERE sal BETWEEN 500 AND 7000
AND deptno = 20;
CREATE UNIQUE INDEX idx_emp_07 ON emp (deptno, sal, empno);
----------------------
EXPLAIN PLAN FOR
SELECT *
FROM EMP, DEPT
WHERE EMP.deptno = DEPT.deptno

AND EMP.empno LIKE '78%';
CREATE UNIQUE INDEX idx_emp_dept_08 ON emp (deptno, empno);
--------------------------
EXPLAIN PLAN FOR
SELECT B.*
FROM EMP A, EMP B
WHERE A.mgr = B.empno
AND A.deptno=30;

SELECT *
FROM TABLE (dbms_xplan.display);

CREATE UNIQUE INDEX idx_emp_emp_09 ON emp (deptno, empno);
commit;