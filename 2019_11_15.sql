--emp ���̺� empno�÷��� �������� RPIMARY KEY ����
--PRIMARY KEY = UNIQUE + NOT NULL;
--UNIQUE ==>�ش� �÷����� UNIGUE IONDEX�� �ڵ����� ����

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
ALTER TABLE emp DROP CONSTRAINT E_TEST; -- ���� ����
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE (dbms_xplan.display);
-- UNIQUE ������������ �����ϱ⶧���� ���ǿ� �´°� �ϳ��� �ٷ� ã��
--|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |

--empno �÷����� �ε����� �����ϴ� ��Ȳ����
--�ٸ��÷� ������ �����͸� ��ȸ�ϴ� ���
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);
--TABLE ACCESS FULL ���̺��� ������ ��� �� �а� ���ǿ� �´� ���� ã��
--|*  1 |  TABLE ACCESS FULL| EMP  |     3 |   261 |     3   (0)| 00:00:01 |

--�ε��� �����ϴ� ��� 2����
--1. UNIQUE ����
--2. ���� ����

--�ε��� ���� �÷��� SELECT ���� ����� ���
--���̺� ������ �ʿ����.
EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);



--�÷��� �ߺ��� ������ non-unique �ε��� ���� ��
--unique index���� �����ȹ ��
--PRIMARY KEY �������� ����(unique �ε��� ����)
ALTER TABLE emp DROP CONSTRAINT pk_emp;


--����ũ �ε��� ����
CREATE INDEX /*UNIQUE*/ IDX_emp_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE (dbms_xplan.display);
--empno���� �������� non-unique�ε��� ���� => empno���� �������� ����(�⺻ ��������, �ɼ��� ���� ���������� ����)
--������ �Ǿ� �־ 7782�� �˻��ϰ� 7782�� �ٸ����� ���ö� ������ �˻��ϰ� ��ħ
--|*  2 |   INDEX RANGE SCAN          | IDX_EMP_01 |     1 |       |     1   (0)| 00:00:01 |

--emp ���̺� job �÷����� �ι�° �ε��� ���� (non-unique index)
--job �÷��� �ٸ� �ο��� job �÷��� �ߺ��� ������ �÷��̴�
CREATE INDEX idx_emp_02 ON emp (job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE (dbms_xplan.display);


--WHERE�� ���� �߰�
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE (dbms_xplan.display);
--MANAGER�� ã���� ���� C�� �����ϴ� �ܾ ���� ����

--emp ���̺� job, ename�÷��� �������� non-unique �ε��� ����(���� 2��)
CREATE INDEX idx_emp_03 ON emp (job, ename);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE (dbms_xplan.display);
-- job�� 'MANAGET'�̰� C�� �����ϴ� �κк��� �ƴѰ� ���� �˻�

--emp ���̺� ename, job �÷����� non-unique �ε��� ���� (�����ſ��� ���� ���� ����)
CREATE INDEX  idx_emp_04 ON emp (ename, job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE '%C';

SELECT *
FROM TABLE (dbms_xplan.display);
-- �ε��� �� ��Ƽ�������� �����ϴ� ���� ����



-- HINT�� ����� �����ȹ ���� => /*+    */ 
-- /*+ */ ��ó�� �ּ��ȿ�+�� ���̸� sql�� ����ڰ� hint�� �شٰ� ������. ������ �߸��Ǿ��� ��� ����
CREATE INDEX  idx_emp_04 ON emp (ename, job);

EXPLAIN PLAN FOR
SELECT /*+ INDEX (emp idx_emp_04) */ *   
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE '%C';

SELECT *
FROM TABLE (dbms_xplan.display);

--INDEX �ǽ�idx1
/*
    CREATE TABLE DEPT TEST AS SELECT * FROM DEPT WHERE 1 = 1
    �������� DEPT_TEST ���̺��� ������ ���� ���ǿ� �´� �ε����� �����ϼ���.
    */
CREATE TABLE DEPT_TEST AS 
SELECT * FROM DEPT WHERE 1 = 1;

SELECT *
FROM DEPT_TEST;
-- deptno�÷��� �������� unique �ε��� ����
CREATE UNIQUE INDEX d_idx_test ON dept_test(deptno);
-- dname �÷��� �������� non-uniuqe �ε��� ����
CREATE INDEX d_idx_test2 ON dept_test(dname);
-- deptno, dname �÷��� �������� non-unique �ε��� ����
CREATE INDEX d_idx_test3 ON dept_test(deptno, dname);

--INDEX �ǽ�idx2
-- �ǽ� idx1���� ������ �ε����� �����ϴ� DDL ���� �ۼ��ϼ���.
DROP INDEX d_idx_test;
DROP INDEX d_idx_test2;
DROP INDEX d_idx_test3;

--INDEX �ǽ�idx3
/*
    �ý��ۿ��� ����ϴ� ������ ������ ���ٰ� �� �� ������ emp ���̺�
    �ʿ��ϴٰ� �����Ǵ� �ε����� ���� ��ũ��Ʈ�� ����� ������.
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