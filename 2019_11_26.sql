SELECT ename, sal, deptno,
       RANK() OVER (PARTITION BY deptno ORDER BY sal) rank,
       DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal) d_rank,
       ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal) rown
FROM emp;
-- PARTITION BY �÷���: �׷����� ����. 


-- �ǽ� ana1
/*
    ����� ��ü �޿� ������ rank,dense_rank, row_number�� �̿��Ͽ� ���ϼ���
    �� �޿��� ������ ��� ����� ���� �縲�� ���������� �ǵ��� �ۼ��ϼ���.
    */
SELECT empno, ename, sal, deptno,
       RANK() OVER (ORDER BY sal desc, empno) sal_rank,
       DENSE_RANK() OVER (ORDER BY sal desc, empno) sal_dense_rank,
       ROW_NUMBER() OVER (ORDER BY sal desc, empno) sal_row_number
FROM emp;

--�ǽ� ana2
/*
    ������ ��� ������ Ȱ���Ͽ�,
    ��� ����� ���� �����ȣ, ����̸�, �ش� ����� ���� �μ��� ��� ����
    ��ȸ�ϴ� ������ �ۼ��ϼ���.
    */
SELECT a.empno, a.ename, a.deptno, b.cnt
FROM 
    (SELECT empno, ename, deptno
    FROM emp) a,
    (SELECT deptno, count(deptno) cnt
    FROM emp
    GROUP BY deptno)b
WHERE a.deptno = b.deptno
ORDER BY deptno, empno;

--�м��Լ��� ���� �μ��� ������ (COUNT)
SELECT ename, empno, deptno,
       COUNT(*) OVER(PARTITION BY deptno) cnt
FROM emp;

--�μ��� ����� �޿� �հ�
--SUM �м��Լ�
SELECT ename, empno, deptno, sal,
       SUM(sal) OVER(PARTITION BY deptno) sum_sal
FROM emp;

--�ǽ� ana2
/*
    window function�� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�,
    ���α޿�, �μ���ȣ�� �ش� ����� ���� �μ��� �޿� ����� ��ȸ�ϴ� ����
    �� �ۼ��ϼ���(�޿� ����� �Ҽ��� ��°�ڸ�����)
    */
SELECT empno, ename, sal, deptno,
       ROUND(AVG(sal) OVER(PARTITION BY deptno),2) cnt
FROM emp;

--�ǽ� ana3
/*
    window function�� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�,
    ���α޿�, �μ���ȣ�� �ش����� ���� �μ��� ������� �޿��� ��ȸ�ϴ�
    ������ �ۼ��ϼ���.
    */
SELECT empno, ename, sal, deptno,
       MAX(sal) OVER(PARTITION BY deptno) max_sal
FROM emp;

--�ǽ� ana4
/*
    window function�� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�,
    ���α޿�, �μ���ȣ�� �ش����� ���� �μ��� �������� �޿��� ��ȸ�ϴ�
    ������ �ۼ��ϼ���.
    */
SELECT empno, ename, sal, deptno,
       MIN(sal) OVER(PARTITION BY deptno) min_sal
FROM emp;

--�μ��� �����ȣ�� ���� �������
--�μ��� �����ȣ�� ���� �������
SELECT empno, ename, deptno,
       FIRST_VALUE (empno) OVER(PARTITION BY deptno ORDER BY empno) f_emp,
       LAST_VALUE (empno) OVER(PARTITION BY deptno ORDER BY empno) l_emp
FROM emp;

--LAG (������)
--������
--LEAD (������)
--�޿��� ���������� ������ �ڱ⺸�� �Ѵܰ� �޿��� ���� ����� �޿�,
--                            �Ѵܰ� �޿��� ���� ����� �޿�

SELECT empno, ename, sal,
       LAG(sal) OVER(ORDER BY sal) lag_sal,
       LEAD(sal) OVER(ORDER BY sal) lead_sal
FROM emp;

--�ǽ� ana5
/*
    window function�� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�,
    �Ի�����, �޿�, ��ü ����� �޿������� 1�ܰ� ���� ����� �޿� ��ȸ�ϴ�
    ������ �ۼ��ϼ���.
    */
SELECT empno, ename, hiredate, sal,
       LEAD(sal) OVER(ORDER BY sal desc, hiredate) lead_sal
FROM emp;

--�ǽ� ana6
/*
    window function�� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�,
    �Ի�����, ����(job),�޿� ������ ������(JOB)�� �޿� ������ 1�ܰ�
    ���� ����� �޿��� ��ȸ�ϴ� ������ �ۼ��ϼ���.
    (�޿��� ���� �ܿ� �Ի����� ���� ����� ��������)
    */
SELECT empno, ename, hiredate, job ,sal,
       LAG(sal) OVER(PARTITION BY job ORDER BY sal desc, hiredate) lag_sal
FROM emp;

--�ǽ� no_ana3
/*
    -��� ����� ���� �����ȣ,����̸�,�Ի�����,�޿��� �޿��� ����������
     ��ȸ�غ���.
    
    -�ڽź��� �޿��� ���� ����� �޿� ���� ���ο� �÷��� �־��
     (window �Լ� ����..)
    */
(SELECT a.empno, a.ename, a.sal ,ROWNUM rn
FROM 
    (SELECT empno, ename, sal
    FROM emp
    ORDER BY sal)a)a;

(select b.sal, b.rn
FROM
    (SELECT b.sal, rownum rn
    FROM 
        (SELECT sal
        FROM emp
        GROUP BY sal
        ORDER BY sal) b)b  
WHERE a.rn = b.rn; 

--������ Ǯ��
SELECT a.empno, a.ename, a.sal, sum(b.sal) sal_sum
FROM
    (SELECT a.empno, a.ename, a.sal ,ROWNUM rn
    FROM 
        (SELECT empno, ename, sal
        FROM emp
        ORDER BY sal)a)a,
    
    (SELECT b.empno, b.ename, b.sal , ROWNUM rn
    FROM 
        (SELECT empno, ename, sal
        FROM emp
        ORDER BY sal)b)b
WHERE a.rn >= b.rn
GROUP BY a.empno, a.ename, a.sal
ORDER BY a.sal, a.empno;
---------------------------

--WINdOWING
--UNBOUNDED PRECEDING : ���� ���� �������� �����ϴ� �����
--CURRENT ROW : ���� ��
--UNBOUNDED FOLLOWING : ���� ���� �������� �����ϴ� �����
--N(����) PRECEDING : ���� ���� �������� �����ϴ� N���� ��
--N(����) FOLLOWING : ���� ���� �������� �����ϴ� N���� ��

-- ROWS BETWEEN ���� AND ��
SELECT empno, ename, sal,
       SUM(sal) OVER(ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_sal, -- �����ϴ� ����� ���������
       
       SUM(sal) OVER(ORDER BY sal, empno 
       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) sum_sal2,    --�����ϴ� ����� �����ϴ� �����
       
       SUM(sal) OVER(ORDER BY sal, empno 
       ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) sum_sal3 --������ ���� ���Ʒ� �ุ
FROM emp;

--�ǽ� ana7
/*
    �����ȣ, ����̸�, �μ���ȣ, �޿������� �μ�����
    �޿�, �����ȣ ������������ ����������, �ڽ��Ǳ޿��� �����ϴ�
    ������� �޿� ���� ��ȸ�ϴ� ������ �ۼ��ϼ���.
(window�Լ� ���)
    */
select empno, ename, deptno, sal,
       sum(sal) over(partition by deptno 
                     order by sal, empno
                     rows between unbounded preceding and current row) c_sum
                     --rows between unbounded preceding and current row) default��
from emp;

--range�Լ�
select empno, ename, deptno, sal,
       sum(sal) over (order by sal 
                      rows between unbounded preceding and current row) row_sum,
       sum(sal) over (order by sal 
                      rows unbounded preceding) row_sum2,
       
       sum(sal) over (order by sal 
                      range between unbounded preceding and current row) range_sum,
       sum(sal) over (order by sal 
                      range unbounded preceding) range_sum2
        -- rows�� ���� ������ ���ε� �ν���.
        -- range�� sal�� ���� �κ��� �ϳ��� ������ �ν���
        
from emp;