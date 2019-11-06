--�׷��Լ�
--multi row function : �������� ���� �Է����� �ϳ��� ��� ���� ����
--SUM, MAX, MIN, AVG, COUNT
-- GROUNP BY col | express
--SELECT ������ GROUP BY ���� ����� COL, EXPRESS ǥ�� ����

--������ ���� ���� �޿��� ��ȸ
-- 14���� ���� �Է����� �� �ϳ��� ����� ����
SELECT MAX(sal) max_sal
FROM emp;

--�μ����� ���� ���� �޿� ��ȸ
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

SELECT *
FROM dept;


--group function �ǽ� grp2
/*
    emp���̺��� �̿��Ͽ� ������ ���Ͻÿ�
    - �μ����� ������ ���� ���� �޿�
    - �μ����� ������ ���� ���� �޿�
    - �μ����� ������ �޿� ���
    - �μ����� ������ �޿� ��
    - �μ��� ������ �޿��� �ִ� ������ ��(NULL����)
    - �μ��� ������ ����ڰ� �ִ� ������ ��(NULL����)
    - �μ��� ��ü ������ ��
*/
SELECT deptno,
       MAX(sal) max_sal,
       MIN(sal) min_sal,
       ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(*) emp_cnt,
       COUNT(sal) sal_cnt,
       COUNT(mgr) mgr_cnt,
       SUM(comm) comm_sum
FROM emp
GROUP BY deptno;
--group function �ǽ� grp3
/*
    emp���̺��� �̿��Ͽ� ������ ���Ͻÿ�.
    - grp2���� ������ ������ Ȱ���Ͽ�
      deptno ��� �μ����� ���ü� �ֵ��� �����Ͻÿ�.
*/
desc emp;

SELECT DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES') dname,
       MAX(sal) max_sal,
       MIN(sal) min_sal,
       ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(*) count_all,
       COUNT(sal) count_sal_,
       COUNT(mgr) count_mgr,
       SUM(comm) comm_sum
FROM emp
GROUP BY  DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES')
ORDER BY DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES');

--group function �ǽ� grp4
/*
    emp���̺��� �̿��Ͽ� ������ ���Ͻÿ�.
    ������ �Ի� ������� ����� ������ �Ի��ߴ���
    ��ȸ�ϴ� ������ �ۼ��ϼ���.
*/

SELECT TO_CHAR(hiredate, 'YYYYMM') hire_yyyymm, COUNT(*)cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYYMM');


--group function �ǽ� grp5
/*
    emp���̺��� �̿��Ͽ� ������ ���Ͻÿ�.
    ������ �Ի� �⺰�� ����� ������ �Ի��ߴ���
    ��ȸ�ϴ� ������ �ۼ��ϼ���.
*/
SELECT TO_CHAR(hiredate, 'YYYY') hire_yyyymm, COUNT(*)cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYY')
ORDER BY TO_CHAR(hiredate,'YYYY');

--group function �ǽ� grp6
/*
    ȸ�翡 �����ϴ� �μ��� ������ ����� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�.
*/
desc dept;
SELECT COUNT(deptno) cnt, count(*) cnt
FROM dept;

SELECT distinct deptno --�ߺ��� ������
FROM emp;

--JOIN
--emp ���̺��� dname �÷��� ���� --> �μ���ȣ (deptno)�ۿ� ����

--emp ���̺� �μ��̸��� �����Ҽ� �ִ� dname �÷��߰�
ALTER TABLE emp ADD (dname VARCHAR2(14));

SELECT *
FROM emp;

UPDATE emp SET dname ='ACCOUNTING' WHERE DEPTNO=10;
UPDATE emp SET dname ='RESEARCH' WHERE DEPTNO=20;
UPDATE emp SET dname ='SALES' WHERE DEPTNO=30;
COMMIT;

SELECT dname, MAX(sal) max_sal
FROM emp
GROUP BY dname;

ALTER TABLE emp DROP COLUMN DNAME;
SELECT *
FROM emp;

--ansi natual join : �����ϴ� ���̺��� �÷����� ���� �÷��� �������� join
SELECT DEPTNO,ENAME,DNAME
FROM emp NATURAL JOIN DEPT;
  
--ORACLE join
SELECT e.deptno , e.ename, e.deptno, d.dname, d.loc --�ߺ��Ǵ� ���� ��Ȯ�ϰ� �����������.
FROM emp e, dept d
WHERE e.deptno = d.deptno;

--ANSI JOING WITH USING
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept USING (deptno);

--from ���� ���δ�� ���̺� ����
--where���� �������� ���
--������ ����ϴ� ���� ���൵ �������
SELECT  emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.job = 'SALESMAN'; --job�� SALES�� ����� ������� ��ȸ
 ------------------------------------- 
SELECT  emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.job = 'SALESMAN'; 
  -------------------------------------
--JOIN with ON (�����ڰ� ���� �÷��� ON���� ���� ���)
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--SELF join : ���� ���̺��� ����
--emp���̺��� mgr ������ �����ϱ� ���ؼ� emp ���̺�� ������ �ؾ��Ѵ�
--a : ��������, b : ������
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a JOIN emp b ON (a.mgr = b.empno)
WHERE a.empno between 7369 AND 7698;

--���� ���ø� oracle join���� �����غ���.
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno
AND a.empno between 7369 AND 7698;

--non-equijoing(��� ������ �ƴѰ��)
SELECT *
FROM salgrade;

--������ �޿� �����????
SELECT *
FROM emp;
--oracle
SELECT emp.empno, emp.ename, emp.sal, salgrade.*
FROM emp, salgrade
WHERE emp.sal BETWEEN salgrade.losal AND salgrade.hisal;

--ansi�� on��
SELECT emp.empno, emp.ename, emp.sal, salgrade.*
FROM emp JOIN salgrade ON(emp.sal BETWEEN salgrade.losal AND salgrade.hisal);

--non equi joing
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr != b.empno
AND a.empno =7369;
------------------------------------------------
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.empno =7369;  --���� ������ ������� �ʾ� a�� 7369�� b�� ��� ����Ǽ��� 14���� �߷� 
-------------------------------------------------
--�ǽ� join0
/*
    emp, dept���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���.
*/
desc emp;
desc dept;
SELECT a.empno, a.ename, b.deptno, b.dname 
FROM emp a, dept b
WHERE a.deptno = b.deptno
ORDER BY a.deptno;
