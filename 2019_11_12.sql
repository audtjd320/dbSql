SELECT *
FROM dept;

INSERT INTO emp (empno,ename, job)
VALUES (9999,'brown', null);

SELECT *
FROM emp
WHERE empno = 9999;

--not null�� �÷��� ��� ���� �Ұ�
--cannot insert NULL into ("PC14"."EMP"."EMPNO")
INSERT INTO emp (ename, job)
VALUES ('brown', null);

rollback;
---------------------------------------------
desc emp;

SELECT *
FROM user_tab_columns
WHERE table_name = 'EMP' -- ã�� ���� ���̺� �̸��� �빮�ڷ� ã�ƾ���(��κ� �빮�ڷ� ����Ǿ�����)
ORDER BY column_id;

--���̺�
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

--SELECT ��� (������)�� INSERT

INSERT INTO emp(empno, ename)
SELECT deptno, dname
FROM dept;

commit;
rollback;
--UPDATE
-- UPDATE ���̺� SET �÷�=��, �÷�=��....
-- WHERE condition;

SELeCT *
FROM dept;

UPDATE dept SET dname ='���IT', loc='ym'
WHERE deptno=99;

SELECT *
FROM emp;

--DELETE ���̺��
--WHERE condition

--�����ȣ�� 9999�� ������ emp ���̺��� ����
DELETE emp
WHERE empno =9999;

--�μ����̺��� �̿��ؼ� emp ���̺� �Է��� 5��(4��)�� �����͸� ����
-- 10, 20, 30, 40, 99 --> empno < 100, empno BETWEEN 10 AND 99
DELETE emp
WHERE empno < 100;

--�����ϱ��� ���� ����Ȯ���ϵ���!!
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
--DML������ ���� Ʈ����� ����
SELECT *
FROM dept;

--DDL : AUTO COMMIT, rollback�� �ȵȴ�.
--CREATE
CREATE TABLE ranger_new(
    ranger_no NUMBER,   --���� Ÿ��
    ranger_name VARCHAR2(50), --���� : [VARCHAR2], CHAR
    reg_dt DATE DEFAULT sysdate --DEFAULT : SYSDATE
);
desc ranger_new;

--DDL�� rollback�� ������� �ʴ´�.
rollback;
--ranger_new���̺� ������ ����
INSERT INTO ranger_new (ranger_no, ranger_name)
VALUES(1000, 'brown');

SELECT *
FROM ranger_new;
commit;


--��¥ Ÿ�Կ��� Ư�� �ʵ尡������
--ex : sysdate���� �⵵�� ��������
SELECT TO_CHAR(sysdate, 'YYYY')
FROM dual;


--EXTRACT�� �̿��Ͽ� ��¥ Ÿ���� Ư�� �ʵ� ��������
SELECT ranger_no, ranger_name, reg_dt,
       TO_CHAR(reg_dt, 'MM'),
       EXTRACT(MONTH FROM reg_dt) mm,
       EXTRACT(YEAR FROM reg_dt) year,
       EXTRACT(DAY FROM reg_dt) day
FROm ranger_new;


--��������
--dept ����ؼ� dept_test ����
desc dept_test;
CREATE TABLE dept_test(
    deptno number(2) PRIMARY KEY, --deptno �÷��� �ĺ��ڷ� ����
    dname varchar2(14),           --�ĺ��ڷ� ������ �Ǹ� ���� �ߺ��� �� �� ������, null�� ���� ����
    loc varchar2(13)    
);

--primary key �������� Ȯ��
-- 1. deptno�÷��� null�� �� �� ����.
-- 2. deptno�÷��� �ߺ��� ���� �� �� ����.

INSERT INTO dept_test (deptno, dname, loc)
VALUES (null, 'ddit', 'daejeon');

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeaon');
INSERT INTO dept_test VALUES (1, 'ddit2', 'daejeaon');
rollback;

--����� ���� �������Ǹ��� �ο��� PRIMARY KEY
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

--���̺� ����(PK�� ������ ���)
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
    dname VARCHAR2(14) UNIQUE, --���� �����ؾ��Ѵ�.
    loc VARCHAR2(13)
);
INSERT INTO dept_test VALUES (1, 'ddit', 'daejeaon');
INSERT INTO dept_test VALUES (2, 'ddit', 'daejeaon'); --������ ���� �Է��ϸ� �ȵ�
rollback;