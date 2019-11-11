--SMITH, WARD�� ���ϴ� �μ��� ������ ��ȸ
SELECT *
FROM emp
WHERE deptno IN (20, 30);

SELECT *
FROM emp
WHERE deptno = 20
   OR deptno = 30;
   
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno 
                 FROM emp 
                 WHERE ename IN (:name1, :name2));
                 
-- ANY : SET�߿� �����ϴ°� �ϳ��� ������ ������(ũ���)
-- SMITH, WARD �λ���� �޿����� ���� �޿��� �޴� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE sal < any(SELECT sal --800, 1250 --> 1250���� ���� �޿��� �޴� ���� ����
                FROM emp
                WHERE ename IN ('SMITH', 'WARD'));
      
-- SMITH�� WARD���� �޿��� ���� ���� ��ȸ
-- SMITH���ٵ� �޿��� ����, WARD���ٵ� �޿��� ���� ���(AND)
SELECT *
FROM emp
WHERE sal > ALL(SELECT sal --800, 1250 --> 1250���� ���� �޿��� �޴� ���� ����
                FROM emp
                WHERE ename IN ('SMITH', 'WARD'));
                
--NOT IN

--�������� ��������
--1. �������� ����� ��ȸ
--  . mgr �÷��� ���� ������ ���� (mgr�� ���� �����ϴ� ����� �����ȣ)
SELECT DISTINCT mgr -- DISTINCT�� �ߺ��� ����
FROM emp;

--� ������ ������ ������ �ϴ� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE empno IN (7839,7782,7698,7902,7566,7788);


SELECT *
FROM emp
WHERE empno IN (SELECT mgr 
                FROM emp);
                
 --�����ڰ� ������ �����ʴ� ���� ���� ��ȸ
 -- �� NOT IN������ ���� SET�� NULL�� ���Ե� ��� ���������� �������� �ʴ´�.
 -- NULLó�� �Լ��� WHERE���� ���� NULL���� ó���� ���� ���
SELECT *
FROM emp       
WHERE empno NOT IN (SELECT mgr 
                FROM emp
                WHERE mgr is not null);
 -- NULLó�� �Լ��� WHERE���� ���� NULL���� ó���� ���� ���
SELECT *
FROM emp       
WHERE empno NOT IN (SELECT NVL(mgr, -9999)
                    FROM emp);
                    
--pair wise
--��� 7499, 7782�� ������ ������, �μ���ȣ ��ȸ
--�����߿� �����ڿ� �μ���ȣ��(7698, 30) �̰ų� (7839, 10)�� ���
-- mgr, deptno �÷��� [����]�� ���� ��Ű�� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE (mgr, deptno) IN(SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN(7499, 7782));
--7698 39
--7839 10
--������ �����ڿ�, �μ���ȣ�� (7698, 30), (7698, 10), (7839, 30), (7839, 10) �� ���� ��ȸ
SELECT *
FROM emp
WHERE mgr IN(SELECT mgr
                FROM emp
                WHERE empno IN(7499, 7782))          
AND deptno IN(SELECT deptno
                FROM emp
                WHERE empno IN(7499, 7782));
                
--SCALAR SUNQUERY : SELECT ���� �����ϴ� ��������(��. ���� �ϳ��� ��, �ϳ��� �÷�)
--������ �Ҽ� �μ����� JOIN�� ������� �ʰ� ��ȸ
SELECT empno, ename, deptno, (SELECT dname
                                FROM dept
                                WHERE dept.deptno = emp.deptno) dname
FROM emp;

SELECT dname
FROM dept
WHERE deptno = 20;

--sub4 ������ ����
/*
    dept ���̺��� �ű� ��ϵ� 99�� �μ��� ���� ����� ����
    ������ ������ ���� �μ��� ��ȸ�ϴ� ������ �ۼ��غ�����.
    */
SELECT *
FROM dept;
INSERT INTO dept VALUES(99, 'ddit', 'daejeon');
COMMIT;
--����
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                     FROM  emp);

--�ǽ� sub5
/*
    cycle, product ���̺��� �̿��Ͽ� cid=1�� ���� �������� �ʴ�
    ��ǰ�� ��ȸ�ϴ� ������ �ۼ��ϼ���.
    */
select *from cycle;
select * from product;

select pid, cid
from cycle
where cid =1;

SELECT *
FROM product
WHERE pid NOT IN (SELECT pid
                    FROM cycle
                    WHERE cid =1); 

--�ǽ� sub6
/*
    cycle ���̺��� �̿��Ͽ� cid=2�� ���� �����ϴ� ��ǰ�� cid=1��
    ���� �����ϴ� ��ǰ�� ���������� ��ȸ�ϴ� ������ �ۼ��ϼ���.
    */

SELECT *FROM cycle;
SELECT *FROM product;

SELECT * 
FROM cycle
WHERE cid = 1
AND pid IN(SELECT pid
             FROM cycle
             WHERE cid = 2);
--�ǽ� sub7
/*
    cycle ���̺��� �̿��Ͽ� cid=2�� ���� �����ϴ� ��ǰ�� cid=1��
    ���� �����ϴ� ��ǰ�� ���������� ��ȸ�ϰ� ����� ��ǰ�����
    �����ϴ� ������ �ۼ��ϼ���.
    */
select * from cycle;
select * from product;
select * from customer;

SELECT cycle.cid, cnm, cycle.pid, pnm, day, cnt 
FROM cycle, customer, product
WHERE cycle.cid = 1
AND cycle.pid IN(SELECT pid
             FROM cycle
             WHERE cid = 2
             )
AND cycle.pid = product.pid
AND cycle.cid = customer.cid;
---------------------------------

    



--EXISTS MAIN������ �÷��� ����ؼ� SUBQUERY�� �����ϴ� ������ �ִ��� üũ
--�����ϴ� ���� �ϳ��� �����ϸ� ���̻� �������� �ʰ� ���߱� ������
--���ɸ鿡�� ����

--MGR�� �����ϴ� ���� ��ȸ
SELECT *
FROM emp a
WHERE EXISTS (SELECT 'X'
              FROM emp
              WHERE empno = a.mgr);

--MGR�� �������� �ʴ� ���� ��ȸ
SELECT *
FROM emp a
WHERE NOT EXISTS (SELECT 'X'
              FROM emp
              WHERE empno = a.mgr);
              
--�ǽ� sub8
-- �Ʒ� ������ subquery�� ������� �ʰ� �ۼ��ϼ���.
-- �Ŵ����� �����ϴ� ���� ��ȸ
SELECT * 
FROM emp a
WHERE EXISTS(SELECT 'X'
             FROM emp b
             WHERE b.empno = a.mgr);

SELECT *
FROM emp
WHERE mgr IS NOT NULL;

--�μ��� �Ҽӵ� ������ �ִ� �μ� ���� ��ȸ
select * from emp;

SELECT *
FROM dept
WHERE EXISTS(SELECT 'X'
             FROM emp
             WHERE deptno = dept.deptno);
--IN
SELECT *
FROM dept
WHERE deptno IN(SELECT deptno
             FROM emp);
            
--�ǽ� sub9
/*
    cycle, product ���̺��� �̿��Ͽ� cid=1�� ���� �������� �ʴ�
    ��ǰ�� ��ȸ�ϴ� ������ EXISTS �����ڸ� �̿��Ͽ� �ۼ��Ͻÿ�.
    */
select * from cycle;
select * from product;
select * from customer;
--EXISTS
SELECT *
FROM product
WHERE  NOT EXISTS(SELECT 'X'
                  FROM cycle
                  where cycle.cid = 1
                  AND cycle.pid = product.pid);
--NOT IN
select *
from product
where pid not in (select pid
                    from cycle
                    where cid = 1);

            
--���տ���
--UNION : ������ �ߺ��� ����
--        DBMS������ �ߺ��� �����ϱ����� �����͸� ����
--        (�뷮�� �����Ϳ� ���� ���Ľ� ����)
--UNION ALL : UNION�� ��������
--            �ߺ��� �������� �ʰ�, �� �Ʒ� ������ ���� => �ߺ�����
--            ���Ʒ� ���տ� �ߺ��Ǵ� �����Ͱ� ���ٴ� ���� Ȯ���ϸ�
--            UNION �����ں��� ���ɸ鿡�� ����
--����� 7566 �Ǵ� 7698dls ��� ��ȸ(����̶�, �̸�)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION
--����� 7369, 7499�� ��� ��ȸ(���,�̸�)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698;
--WHERE empno =7369 OR empno = 7499;

--UNION ALL(�ߺ� ���, �� �Ʒ� ������ ��ġ�⸸ �Ѵ�)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION ALL
--����� 7369, 7499�� ��� ��ȸ(���,�̸�)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698;
--WHERE empno =7369 OR empno = 7499;


--INTERSECT(������ : �� �Ʒ� ���հ� ����� ������)
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698,7369)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN (7566 ,7698,7499);

--MINUS(������ : �� ���տ��� �Ʒ� ������ ����)
--������ ���� : ���� �ִ� ������ ����
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698,7369)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN (7566 ,7698,7499);
















SELECT *
FROM USER_CONSTRAINTS
WHERE OWNER = 'PC14'
AND TABLE_NAME IN('PROD', 'LPROD')
AND CONSTRAINT_TYPE IN('P','R');









