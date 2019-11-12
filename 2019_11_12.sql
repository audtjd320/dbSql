SELECT *
FROM dept;

INSERT INTO emp (empno,ename, job)
VALUES (9999,'brown', null);

SELECT *
FROM emp
WHERE empno = 9999;

--not null인 컬럼인 경우 생략 불가
--cannot insert NULL into ("PC14"."EMP"."EMPNO")
INSERT INTO emp (ename, job)
VALUES ('brown', null);

rollback;
---------------------------------------------
desc emp;

SELECT *
FROM user_tab_columns
WHERE table_name = 'EMP' -- 찾고 싶은 테이블 이름을 대문자로 찾아야함(대부분 대문자로 저장되어있음)
ORDER BY column_id;

--테이블
1.EMPNO
2.ENAME
3.JOB
4.MGR
5.HIREDATE
6.SAL
7.COMM
8.DEPTNO

INSERT INTO emp
VALUES (9999, 'brown', 'ranger', null, sysdate, 2500, null, 40);

commit;
SELECT *
FROM emp;

--SELECT 결과 (여러건)를 INSERT

INSERT INTO emp(empno, ename)
SELECT deptno, dname
FROM dept;

commit;
rollback;
--UPDATE
-- UPDATE 테이블 SET 컬럼=값, 컬럼=값....
-- WHERE condition;

SELeCT *
FROM dept;

UPDATE dept SET dname ='대덕IT', loc='ym'
WHERE deptno=99;

SELECT *
FROM emp;

--DELETE 테이블명
--WHERE condition

--사원번호가 9999인 직원을 emp 테이블에서 삭제
DELETE emp
WHERE empno =9999;

--부서테이블을 이용해서 emp 테이블에 입력한 5건(4건)의 데이터를 삭제
-- 10, 20, 30, 40, 99 --> empno < 100, empno BETWEEN 10 AND 99
DELETE emp
WHERE empno < 100;

--삭제하기전 삭제 내용확인하도록!!
SELECT *
FROM emp
WHERE empno < 100;

DELETE emp
WHERE empno BETWEEN 10 AND 99;

SELECT *
FROM emp
WHERE empno BETWEEN 10 AND 99;

ROLLBACK;

DELETE emp
WHERE empno IN(SELECT deptno FROM dept);

SELECT *
FROM emp
WHERE empno IN(SELECT deptno FROM dept);

DELETE EMP
WHERE EMPNO=9999;

COMMIT;

--LV1 --> LV3
SET TRANSACTION
isolation LEVEL SERIALIZABLE;

SET TRANSACTION
isolation LEVEL READ COMMITTED;
ROLLBACK;
--DML문장을 통해 트랜잭셕 시작
SELECT *
FROM dept;

--DDL : AUTO COMMIT, rollback이 안된다.
--CREATE
CREATE TABLE ranger_new(
    ranger_no NUMBER,   --숫자 타입
    ranger_name VARCHAR2(50), --문자 : [VARCHAR2], CHAR
    reg_dt DATE DEFAULT sysdate --DEFAULT : SYSDATE
);
desc ranger_new;

--DDL은 rollback이 적용되지 않는다.
rollback;
--ranger_new테이블에 데이터 삽입
INSERT INTO ranger_new (ranger_no, ranger_name)
VALUES(1000, 'brown');

SELECT *
FROM ranger_new;
commit;


--날짜 타입에서 특정 필드가져오기
--ex : sysdate에서 년도만 가져오기
SELECT TO_CHAR(sysdate, 'YYYY')
FROM dual;


--EXTRACT를 이용하여 날짜 타입중 특정 필드 가져오기
SELECT ranger_no, ranger_name, reg_dt,
       TO_CHAR(reg_dt, 'MM'),
       EXTRACT(MONTH FROM reg_dt) mm,
       EXTRACT(YEAR FROM reg_dt) year,
       EXTRACT(DAY FROM reg_dt) day
FROm ranger_new;


--제약조건
--dept 모방해서 dept_test 생성
desc dept_test;
CREATE TABLE dept_test(
    deptno number(2) PRIMARY KEY, --deptno 컬럼을 식별자로 지정
    dname varchar2(14),           --식별자로 지정이 되면 값이 중복이 될 수 없으며, null일 수도 없다
    loc varchar2(13)    
);

--primary key 제약조건 확인
-- 1. deptno컬럼에 null이 들어갈 수 없다.
-- 2. deptno컬럼에 중복된 값이 들어갈 수 없다.

INSERT INTO dept_test (deptno, dname, loc)
VALUES (null, 'ddit', 'daejeon');

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeaon');
INSERT INTO dept_test VALUES (1, 'ddit2', 'daejeaon');
rollback;

--사용자 지정 제약조건명을 부여한 PRIMARY KEY
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno number(2) CONSTRAINT PK_DEPT_TEST PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

--TABLE CONSTRAINT
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno number(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT PK_DEPT_TEST PRIMARY KEY(deptno, dname)
);

--테이블 레벨(PK가 복합인 경우)
INSERT INTO dept_test VALUES (1, 'ddit', 'daejeaon');
INSERT INTO dept_test VALUES (1, 'ddit2', 'daejeaon');
select *
from dept_test;
rollback;

--NOT NULL
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) NOT NULL,
    loc VARCHAR2(13)
);
INSERT INTO dept_test VALUES (1, 'ddit', 'daejeaon');
INSERT INTO dept_test VALUES (2, null, 'daejeaon');

--UNIQUE
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) UNIQUE, --값이 유일해야한다.
    loc VARCHAR2(13)
);
INSERT INTO dept_test VALUES (1, 'ddit', 'daejeaon');
INSERT INTO dept_test VALUES (2, 'ddit', 'daejeaon'); --동일한 값을 입력하면 안들어감
rollback;