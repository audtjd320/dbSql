--��� �Ķ���Ͱ� �־����� �� �ش����� �ϼ��� ���ϴ� ����
--201911 --> 30 / 201912 --> 31

-- �Ѵ� ������ �������� ���� = �ϼ�
-- ������ ��¥ ���� �� --> DD�� ����
--SELECT TO_CHAR(LAST_DAY(TO_DATE('201911', 'YYYYMM')), 'DD') day_cnt
SELECT :YYYYMM as param, TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD') DT
FROM DUAL;

explain plan for
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

SELECT empno, ename, sal, TO_CHAR(sal, 'L0009999,999.99') sal_fmt
FROM emp;

--function 
--nvl(coll, coll�� null�� ��� ��ü�� ��) (�߿�!!)
SELECT empno, ename, comm, nvl(comm, 0) nvl_comm,
       sal + comm, sal + nvl(comm, 0), nvl(sal + comm, 0)
FROM emp;

--NVL2(coll, coll�� null�� �ƴ� ���  ǥ���Ǵ� ��, coll�� null�� ��� ǥ���Ǵ� ��)
SELECT empno, ename, sal, comm, NVL2(comm, 0, comm) + sal
FROM emp;

--NULLIF(expr1, expr2)
--expr1 == expr2 ������ null
--else : expr1
SELECT empno, ename, sal, comm, NULLIF(sal, 1250)
FROM emp;

--COALESCE(expr1, expr2, expr3...)
--�Լ� ������ ���� null�� �ƴ� ù��° ����
SELECT empno, ename, sal, comm, coalesce(comm, sal)
FROM emp;

--null �ǽ� fn4
/*
    emp���̺��� ������ ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���
*/
desc emp;
SELECT empno, ename, mgr, NVL(mgr, 9999)as mgr_n, NVL2(mgr, mgr, 9999)as mgr_n,coalesce(mgr,9999) as mgr_n
FROM emp;


--null �ǽ� fn5
-- users���̺��� ������ ���������� ��ȸ�ǵ��� ������ �ۼ��ϼ���
-- reg_dt�� null�� ��� sysdate�� ����
SELECT userid, usernm, reg_dt, NVL(reg_dt, sysdate) as n_reg_dt
FROM USERS;

--case when
SELECT empno, ename, job, sal,
       case
            when job ='SALESMAN' then sal*1.05
            when job ='MANAGER' then sal*1.10
            when job ='PRESIDENT' then sal*1.20
            else sal
       end case_sal
FROM emp;

--decode(col, search1, return1m search2, return2.....default)
SELECT empno, ename, job, sal,
       DECODE(job, 'SALESMAN', sal*1.05,
                   'MANAGER', sal*1.10, 
                   'PRESIDENT', sal*1.20, 
                    sal) decode_sal
FROM emp;

--condition �ǽ� cond1
/*
    emp ���̺��� �̿��Ͽ� deptno�� ���� �μ������� ���� �ؼ�
    ������ ���� ��Î���� ������ �ۼ��ϼ���
*/
    
SELECT empno, ename,
       case
            when deptno = 10 then 'ACCOUNTING'
            when deptno = 20 then 'RESEARCH'
            when deptno = 30 then 'SALES'
            when deptno = 40 then 'OPERATIONS'
            else 'DDIT'
       end dname
FROM emp;

--condition �ǽ� cond2
/*
    emp ���̺��� �̿��Ͽ� hiredate�� ���� ���� �ǰ����� ����
    ��������� ��ȸ�ϴ� ������ �ۼ��ϼ���.
    (������ �������� �ϳ� ���⼭�� �Ի�⵵�� �������� �Ѵ�)
    
    HINT) ������ ���ϴ°��� MOD
*/
SELECT empno, ename, to_char(hiredate, 'YYYY/MM/DD') hiredate,
    
       DECODE (MOD(TO_CHAR(SYSDATE,'YY'),2),0,'�ǰ����� �����',1,'�ǰ����� ������') contact_to_doctor

FROM emp;

-----------------�� Ǯ��---------------------
--���ش� ¦���ΰ�? Ȧ���ΰ�?
--1.���� �⵵ ���ϱ� (DATE -> TO_CHAR(DATE, FORMAT)
--2.���� �⵵�� ¦������ ���
-- ����� 2�� ������ �������� �׻� 2���� �۴�
-- 2�� ������� �������� 0,1
-- MOD(���, ������)
SELECT MOD(TO_CHAR(SYSDATE, 'YYYY'), 2)
FROM DUAL;

--emp ���̺��� �Ի����ڰ� Ȧ�������� ¦�������� Ȯ��
-- �Ի�⵵�� ���س⵵�� Ȧ¦�� ���ΰ� ������
SELECT empno, ename, hiredate,
       case
        when MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) = MOD(TO_CHAR(hiredate, 'YYYY'), 2)
            then '�ǰ����� ���'
            else '�ǰ����� ������'
        end contact_to_doctor
FROM emp;

--condition �ǽ� cond3
/*
    users ���̺��� �̿��Ͽ� reg_dt�� ���� ���� �ǰ����� ����
    ��������� ��ȸ�ϴ� ������ �ۼ��ϼ���.
    (������ �������� �ϳ��� ���⼭�� reg_dt�� �������� �Ѵ�)
*/
SELECT userid, usernm, reg_dt,
       case
        when MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) = MOD(TO_CHAR(reg_dt, 'YYYY'), 2) --�ٽ�
            then '�ǰ����� ���'
            else '�ǰ����� ������'
        end contact_to_doctor
FROM users;


--�׷��Լ� ( AVG, MAX, MIN, SUM, COUNT )
--�׷��Լ��� NULL���� ����󿡼� �����Ѵ�
--SUM(comm), COUNT(*), COUNT(MGR)
--������ ���� ���� �޿��� �޴»���� �޿�
--������ ���� ���� �޿��� �޴»���� �޿�
--������ �޿� ��� (�Ҽ��� ��°�ڸ� ������ ������ --> �Ҽ��� 3°�ڸ����� �ݿø�)
--������ �޿� ��ü��
--������ ��
SELECT MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(*) emp_cnt,
       COUNT(sal) sal_cnt,
       COUNT(mgr) mgr_cnt,
       SUM(comm) comm_sum
FROM emp;

--�μ��� ���� ���� �޿��� �޴»���� �޿�
--GROUP BY ���� ������� ���� �÷��� SELECT���� ����� ��� ����
SELECT deptno, ename, MAX(sal) max_sal
FROM emp
GROUP BY deptno;


----------------------------------------------------------------------
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(*) emp_cnt,
       COUNT(sal) sal_cnt,
       COUNT(mgr) mgr_cnt,
       SUM(comm) comm_sum
FROM emp
GROUP BY deptno;
----------------------------------------------------------------------
SELECT *
FROM emp;

SELECT empno, ename, sal
FROM emp
ORDER BY sal;

--�μ��� �ִ� �޿�
--�׷��Լ������� WHERE �������� ����Ҽ� ���� ���� HAVING���� �̿��Ѵ�.
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno
HAVING MAX(sal) > 3000;

--group function �ǽ� grp1
/*
    emp���̺��� �̿��Ͽ� ������ ���Ͻÿ�
    - ������ ���� ���� �޿�
    - ������ ���� ���� �޿�
    - ������ �޿� ���
    - ������ �޿� ��
    - ������ �޿��� �ִ� ������ ��(NULL����)
    - ������ ����ڰ� �ִ� ������ ��(NULL����)
    - ��ü ������ ��
*/
SELECT MAX(sal) max_sal,
       MIN(sal) min_sal,
       AVG(sal) avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal) count_sal,
       COUNT(mgr) count_mgr,
       COUNT(*) count_all
FROM emp;

SELECT *
FROM EMP;

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