--member ���̺��� �̿��Ͽ� member2 ���̺� ����
--member2 ���̺���
--������ ȸ��(mem_id='a001')�� ����(mem_id)�� '����'���� ������
--commit�ϰ� ��ȸ

CREATE TABLE member2 AS
SELECT *
FROM member;

SELECT *
FROM member2;

UPDATE member2 SET mem_job = '����'
WHERE mem_id = 'a001';
commit;

SELECT mem_id, mem_name, mem_job
FROM member2
WHERE mem_id = 'a001';

--��ǰ�� ��ǰ ���� ����(BUY_QTY) �հ�, ��ǰ ���� �ݾ�(BUY_COST) �հ�
--��ǰ�ڵ�, ��ǰ��, �����հ�, �ݾ��հ�
--VW_PROD_BUY(view ����)
select * from buyprod;
select * from prod;

CREATE OR REPLACE VIEW vw_prod_buy AS 
SELECT buy_prod, prod_name, SUM(buy_qty) sum_qty, SUM(buy_cost) sum_cost
FROM buyprod a, prod b
WHERE a.buy_prod = b.prod_id
GROUP BY buy_prod, prod_name, buy_prod;

select *
from user_views;

--�м��Լ�/window�Լ�(�����غ��� �ǽ�ana0)
/*
    ����� �μ��� �޿�(sal)�� ���� ���ϱ�
    emp ���̺� ���
    */
SELECT *
FROM emp;

select b.*, decode(deptno, 20, rownum)
from
(select a.* , decode(a. deptno,10, rownum)
from
    (select ename, sal, deptno
    from emp
    group by ename, sal, deptno
    order by deptno, sal desc) a
where deptno = (select deptno
                from emp
                where emp.deptno = a.deptno
                group by deptno))b;
--������ Ǯ��
--�μ��� ��ŷ
SELECT a.ename, a.sal, a.deptno, b.rn
FROM
    (SELECT a.ename, a.sal, a.deptno, ROWNUM j_rn
     FROM
    (SELECT ename, sal, deptno
     FROM emp
     ORDER BY deptno, sal DESC) a ) a, 
(SELECT b.rn, ROWNUM j_rn
FROM 
(SELECT a.deptno, b.rn 
 FROM
    (SELECT deptno, COUNT(*) cnt --3, 5, 6
     FROM emp
     GROUP BY deptno )a,
    (SELECT ROWNUM rn --1~14
     FROM emp) b
WHERE  a.cnt >= b.rn
ORDER BY a.deptno, b.rn ) b ) b
WHERE a.j_rn = b.j_rn;

select ename, sal, deptno,
       row_number() over(partition by deptno order by sal desc) rank
from emp;