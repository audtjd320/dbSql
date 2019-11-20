
--GROUPING (cube, rollup ���� ���� �÷�)
-- �ش� �÷��� �Ұ� ��꿡 ���� ���1
-- ������ ���� ��� 0

--job �÷�
-- case1. GROUPING(job)=1 AND GROUPING(deptno) = 1
--        job --> '�Ѱ�'
--case else
--        job --> job


SELECT CASE WHEN GROUPING(job) = 1 AND GROUPING(deptno) = 1 THEN '�Ѱ�'    
            ELSE job   
        END job,
       CASE WHEN GROUPING(job) = 0 AND GROUPING(deptno) = 1 THEN '�Ұ�'
            ELSE TO_CHAR(deptno)
        END deptno,
        GROUPING(job), GROUPING(deptno), sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

--�ǽ�GROUP_AD3
--table : emp
--���� : group by ���� �ѹ��� ���

SELECT deptno, job, SUM(sal) sal
FROM emp
GROUP BY ROLLUP(deptno, job);

--�ǽ�GROUP_AD4
--AD3���� �μ���ȣ ->�μ���
SELECT dname ,job, SUM(sal) sal
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP(dname, job)
ORDER BY dname, job desc;

--�ǽ�GROUP_AD5
--AD4���� ���� row�� ���dname�÷��� '����'���� ǥ��
SELECT case WHEN GROUPING(dname) = 1 AND GROUPING(job) = 1 THEN '����'
            ELSE dname
            end dname,
            job, SUM(sal) sal
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP(dname, job)
ORDER BY dname, job desc;







----------------------------
select *
from dept;
--CUBE (col1, col2...)
--CUBE ���� ������ �÷��� ������ ��� ���տ� ���� ���� �׷����� ����
--CUBE�� ������ �÷��� ���� ���⼺�� ����(rollup���� ����)
--GROUP BY CUBE(job, deptno)
--00 : GROUP BY job, deptno
--0X : GROUP BY job
--X0 : GROUP BY deptno
--XX : GROUP BY --��� �����Ϳ� ���ؼ�... 



--GROUP BY CUBE(job, deptno, mgr) -- 8���� 2��3��

SELECT deptno, job, SUM(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

--subquery�� ���� ������Ʈ
drop table emp_test;

--emp���̺��� �����͸� �����ؼ� ��� �÷��� �̿��Ͽ� emp_test���̺�� ����
create table emp_test AS
select *
from emp;

--emp_test ���̺� dept���̺��� �����ǰ� �ִ� dname �÷�(VARCHAR2(14))�� �߰�
ALTER TABLE emp_test ADD (dname VARCHAR2(14));

select *
FROM EMP_TEST;

--emp_test���̺��� dname�÷��� dept���̺��� dname�÷� ������ ������Ʈ�ϴ�
--���� �ۼ�
UPDATE emp_test SET dname = (SELECT dname
                             FROM dept
                             WHERE dept.deptno = emp_test.deptno);
commit;
SELECT *
FROM dept_test;
drop table dept_test;
--�ǽ�sub_a1
--dept���̺��� �̿��Ͽ� dept_test ���̺� ����
CREATE TABLE dept_test AS
SELECT *
FROM dept;
--dept_test ���̺� empcnt(number) �÷� �߰�
ALTER TABLE dept_test ADD(empcnt NUMBER);

--subquery�� �̿��Ͽ� dept_test���̺��� empcnt �÷���
--�ش� �μ��� ���� update������ �ۼ��ϼ���.
UPDATE dept_test SET empcnt = (SELECT count(*) cnt --cnt��  0�̸� null�� ��.
                               FROM EMP
                               WHERE emp.deptno = dept_test.deptno
                               group by deptno);

SELECT deptno, count(*)
FROM EMP
group by deptno
GROUP BY deptno;

--������ Ǯ�� --cnt��0�̸� 0��
UPDATE dept_test SET empcnt = (SELECT count(*) cnt
                               FROM EMP
                               WHERE deptno = dept_test.deptno);
SELECT *
FROM dept_test;

--
SELECT *
FROM dept_test;
INSERT INTO dept_test VALUES (98, 'it','daejeon','0');
INSERT INTO dept_test VALUES (99, 'it','daejeon','0');
rollback;
--�ǽ�sub_a2
--dept���̺��� �̿��Ͽ� dept_test���̺� ����
--dept_test ���̺� �ű� ������ 2�� �߰�
--  INSERT INTO dept_test VALUES (98, 'it','daejeon','0');
--  INSERT INTO dept_test VALUES (99, 'it','daejeon','0');
--emp ���̺��� �������� ������ ���� �μ� ���� �����ϴ� ������ ���������� �̿��Ͽ� �ۼ��ϼ���.
DELETE FROM dept_test 
WHERE empcnt not in (select count(*)
                    FROM emp
                    where emp.deptno = dept_test.deptno
                    Group by deptno);
rollback;
delete dept_test
where not exists (select 'x'
                  from emp  
                  where emp.deptno = dept_test.deptno);

delete dept_test
where deptno not in (select deptno
                     from emp);

--�ǽ� sub_a3
--emp���̺��� �̿��Ͽ� emp_test ���̺� ����
create table emp_test AS select * from emp;
/*
    subquery�� �̿��Ͽ� emp_test ���̺��� ������ ���� �μ��� 
    (sal)��� �޿����� �޿��� ���� ������ �޿��� �� �޿����� 200��
    �߰��ؼ� ������Ʈ �ϴ� ������ �ۼ��ϼ���.
    */
select ename, deptno, sal from emp_test order by deptno;     

--STEP1 -
select ename, deptno, sal
from emp_test a
where sal <(select round(avg(sal),2)
            from emp_test b
            where a.deptno = b.deptno);
--update�� ����
UPDATE emp_test a SET sal = sal + 200
where sal <(select avg(sal)
            from emp_test b
            where a.deptno = b.deptno);

--emp, emp_test empno�÷����� ���������� ��ȸ
--1. emp.empno, emp.ename, emp.sal, emp_test.sal
SELECT emp.empno, emp.ename, emp.sal, emp_test.sal
FROM emp, emp_test
where emp.empno= emp_test.empno;
/*
    2. emp.empno, emp.ename, emp.sal, emp_test.sal,
       �ش���(emp���̺� ����)�� ���� �μ��� �޿����
       */
SELECT emp.empno, emp.ename, emp.sal, emp_test.sal, emp.deptno, (select round(avg(sal),2)
                                                                 from emp
                                                                 where emp.deptno= emp_test.deptno
                                                                 group by deptno)avg_sal
FROM emp, emp_test
where emp.empno= emp_test.empno;