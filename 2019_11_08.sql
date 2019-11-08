--���κ���
--���� �� ??
--RDBMS�� Ư���� ������ �ߺ��� �ִ� ������ ���踦 �Ѵ�
--EMP ���̺��� ������ ������ ����, �ش� ������ �Ҽ� �μ�������
-- �μ���ȣ�� �����ְ�, �μ���ȣ�� ���� dept ���̺�� ������ ����
-- �ش� �μ��� ������ ������ �� �ִ�.

--���� ��ȣ, �����̸�, ������ �Ҽ� �μ���ȣ, �μ��̸�
SELECT emp.empno, emp.ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--�μ���ȣ, �μ���, �ش�μ��� �ο���
--count(col) : col���� �����ϸ� 1, null : 0
--             ����� �ñ��� ���̸� *
SELECT *FROM EMP; SELECT *FROM DEPT;
SELECT emp.deptno, dname,count(empno) cnt
FROM dept, emp
WHERE emp.deptno = dept.deptno
GROUP BY  emp.deptno, dname;

--TOTAL ROW : 14
SELECT count(*), count(empno), count(mgr), count(comm)
FROM emp;

--OUTER JOIN : ���ο� ���е� ������ �Ǵ� ���̺��� �����ʹ� ��ȸ�����
--              �������� �ϴ� ���� ����
--LEFT OUTER JOIN : JOIN KEYWORD ���ʿ� ��ġ�� ���̺��� ��ȸ ������
--                    �ǵ��� �ϴ� ���� ����
--RIGHT OUTER JOIN : JOIN KEYWORD �����ʿ� ��ġ�� ���̺��� ��ȸ ������
--                    �ǵ��� �ϴ� ���� ����
--FULL OUTER JOIN : LEFT OUTER JOIN + RIGHT OUTER JOIN - �ߺ�����

--���������� �ش� ������ ������ ���� outer join
--������ȣ, �����̸�, ������ ��ȣ, ������ �̸�

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON(a.mgr = b.empno);

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a  JOIN emp b ON(a.mgr = b.empno);

--oracle outer join (left, right�� ���� fullouter�� �������� ����)
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+);

--ANSI LEFT OUTER
SELECT a.empno, a.ename, a.mgr, b.ename -- b.ename ������ �Ŵ��� ����(a.mgr = b.empno)
FROM emp a LEFT OUTER JOIN emp b ON(a.mgr = b.empno AND b.deptno=10); --b.deptno=10�� ������ ������

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON(a.mgr = b.empno)
WHERE b.deptno =10; --������ ������ b.deptno=10


--oracle outer ���������� outer ���̺��� �Ǵ� ��� �÷��� (+)�� �ٿ����
-- outer joing�� ���������� �����Ѵ�.
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+)
ANd B.deptno(+) = 10;


--ANSI RIGHT OUTER
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a RIGHT OUTER JOIN emp b ON(a.mgr = b.empno);

--�ǽ� outerjoin1
/*
    buyprod���̺� �������ڰ� 2005�� 1�� 25���� �����ʹ� 3ǰ�� �ۿ� ����.
    ��� ǰ���� ���ü� �ֵ��� ������ �ۼ��� ������
*/
--ANSI
select * from buyprod;
select * from prod;
SELECT a.buy_date, a.buy_prod, b.prod_id, b.prod_name, a.buy_qty
FROM buyprod a right OUTER JOIN prod b ON(a.buy_prod = b.prod_id AND a.buy_date = '20050125');

--oracle
SELECT b.buy_date, b.buy_prod, a.prod_id, a.prod_name, b.buy_qty
FROM  prod a, buyprod b
WHERE a.prod_id = b.buy_prod(+) --���� �ݴ뿡(+)�ٿ��ش�
AND b.buy_date(+)= TO_DATE('20050125','YYYYMMDD');

--�ǽ� outerjoin2
/*
    
    outerjoin1���� �۾��� �����ϼ���. buy_date�÷��� null�� �׸��� �ȳ�������
    ����ó�� �����͸� ä�������� ������ �ۼ��ϼ���.
*/
SELECT TO_DATE('20050125','YYYYMMDD') buy_date, b.buy_prod, a.prod_id, a.prod_name, b.buy_qty
FROM  prod a, buyprod b
WHERE a.prod_id = b.buy_prod(+) 
AND b.buy_date(+) = TO_DATE('20050125','YYYYMMDD');

--�ǽ� outerjoin3
/*
    outerjoin2���� �۾��� �����ϼ���. buy_qty �÷��� null�� ��� 0���� ���̵���
    ������ �����ϼ���.
*/
SELECT TO_DATE('20050125','YYYYMMDD') buy_date, b.buy_prod, a.prod_id, a.prod_name, NVL(b.buy_qty,0)
FROM  prod a, buyprod b
WHERE a.prod_id = b.buy_prod(+) 
AND b.buy_date(+) = TO_DATE('20050125','YYYYMMDD');

--�ǽ� outerjoin4
/*
    cycle, product���̺��� �̿��Ͽ� ���� �����ϴ� ��ǰ ��Ī�� ǥ���ϰ�,
    �������� �ʴ� ��ǰ�� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���.
    (���� cid=1�� ���� �������� ����,nulló��)
    */
SELECT *FROM CYCLE;
SELECT*FROM PRODUCT;

SELECT b.pid, b.pnm, NVL(a.cid,1) cid, NVL(day,0) day, NVL(cnt,0) cnt
FROM cycle a, product b
WHERE a.pid(+) = b.pid
ANd a.cid(+) = 1;

--�ǽ� outerjoin5
/*
     cycle, product���̺��� �̿��Ͽ� ���� �����ϴ� ��ǰ ��Ī�� ǥ���ϰ�,
     �������� �ʴ� ��ǰ�� ������ ���� ��ȸ�Ǹ�, ���̸��� �����Ͽ� ������
     �ۼ��ϼ���.
     (���� cid=1�� ���� �������� ����,nulló��)
     */
SELECT ab.pid, pnm,  ab.cid, cnm , day,  cnt  --��ġ�� �̸��� inline veiw�� ��Ī
FROM
    (SELECT b.pid, b.pnm, NVL(a.cid,1) cid, NVL(day,0) day, NVL(cnt,0) cnt
    FROM cycle a, product b
    WHERE a.pid(+) = b.pid
    ANd a.cid(+) = 1)  , customer c
WHERE ab.cid = c.cid
ORDER BY pid desc, day desc;

--�ǽ� crossjoin1
/*
    customer, product���̺��� �̿��Ͽ� ���� ���� ������ ��� ��ǰ��
    ������ �����Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���.
    */
-- CROSS JOIN�� WHERE���� �ʿ����.

--ORACLE    
SELECT cid, cnm, pid, pnm
FROM customer, product;

--ANSI
SELECT *
FROM customer CROSS JOIN product;


--subquery : main������ ���ϴ� �κ� ����
--���Ǵ� ��ġ :
-- SELECT - scalar subquery(�ϳ��� ���, �ϳ��� �÷��� ��ȸ�Ǵ� �����̾�� �Ѵ�)
-- FROM - inline view
-- WHERE - subquery

--SCALAR subquery
SELECT empno, ename, SYSDATE now/*���糯¥*/
FROM emp;

SELECT empno, ename, (SELECT SYSDATE FROM dual) now --SELECT�� �ȿ� SELECT������ �ϳ��� �÷��� ��ȸ����, �ΰ��̻��� ����)
FROM emp;

--'SMITH'�� ���� �μ��� ����
SELECT deptno  --20
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM emp
WHERE deptno = 20;

SELECT *
FROM emp
WHERE deptno = (SELECT deptno  --20
                FROM emp
                WHERE ename = 'SMITH');

--�ǽ� SUB1
--��� �޿����� ���� �޿��� �޴� ������ ���� ��ȸ�ϼ���.
SELECT empno
FROM emp;

SELECT AVG(sal) --2073.21
FROM emp;

SELECT count(*)
FROM emp
WHERE sal >(SELECT AVG(sal) --2073.21
            FROM emp);
--�ǽ� SUB2
--��� �޿����� �����޿��� �޴� ������ ������ ��ȸ�ϼ���.
SELECT *
FROM emp
WHERE sal >(SELECT AVG(sal) --2073.21
            FROM emp);
            
--�ǽ� SUB3
/*
    SMITH�� WARD����� ���� �μ��� ��� ��� ������ ��ȸ�ϴ� ������ ������ ���� �ۼ��ϼ���.
    */

SELECT *
FROM emp
WHERE deptno IN (SELECT deptno 
                FROM emp 
                WHERE ename IN('SMITH', 'WARD'));
