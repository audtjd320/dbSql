--���̺��� ������ ��ȸ
/*
    SELECT �÷� | express (���ڿ� ���) [as] ��Ī
    FROM �����͸� ��ȸ�� ���̺�(VIEW)
    WHERE ���� (condition)
*/

DESC user_tables;


SELECT *
 from user_tables;
 ----------------------------��������----------------------------
 -- ���� �� ����
 -- �μ���ȣ�� 30�� ���� ũ�ų� ���� �μ��� ���� ���� ��ȸ
 SELECT * 
 FROM emp
 WHERE deptno >= 30;
 
 -- �μ���ȣ�� 30������ ���� �μ��� ���� ���� ��ȸ;
 SELECT * 
 FROM emp
 WHERE deptno < 30;
 
--�Ի����ڰ� 1982�� 1�� 1�� ������ ���� ��ȸ
 SELECT * 
 FROM emp
-- WHERE hiredate < '82/01/01'; --ȯ�漳���� �����ͺ��̽��� ��¥������ ����Ǿ��־ ��¥ �������� �ν���.
 WHERE hiredate >= TO_DATE('01011982', 'MMDDYYYY'); --�̱� ��¥ ����(��,��,����)
-- WHERE hiredate >= TO_DATE('19820101', 'YYYYMMDD');
-- WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD');

--BETWEEN X AND Y ����
--�÷��� ���� X���� ũ�ų� ����, Y���� �۰ų� ���� ������
--�޿���(sal)�� 1000���� ũ�ų� ����, 2000���� �۰ų� ���� �����͸� ��ȸ
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

--���� BETWEEN AND �����ڴ� �Ʒ��� <=, >= ���հ� ����
SELECT *
FROM emp
WHERE sal >= 1000
  AND sal <= 2000
  AND deptno = 30;
  
--�ǽ�1 : ���ǿ� �´� ������ ��ȸ�ϱ�( BETWEEN...AND...�ǽ� where1)
/*
    emp ���̺��� �Ի� ���ڰ� 1982�� 1�� 1�� ���ĺ���
    1983�� 1�� 1�� ������ ����� ename, hiredate �����͸�
    ��ȸ�ϴ� ������ �ۼ��Ͻÿ�.
    ��, �����ڴ� between�� ����Ѵ�.
*/

SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE(19820101, 'YYYYMMDD') AND TO_DATE(19830101,'YYYYMMDD');

--�ǽ�2 : ���ǿ� �´� ������ ��ȸ�ϱ�(>=, >, <=, < �ǽ� where2)
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE(19820101,'YYYYMMDD')
  AND hiredate <=  TO_DATE(19830101,'YYYYMMDD');
  

-- IN ������
-- COL IN (values....)
-- �μ���ȣ�� 10 Ȥ�� 20�� ���� ��ȸ

SELECT *
FROM emp
WHERE deptno in(10,20);


--IN �����ڴ� OR �����ڷ� ǥ���� �� �ִ�.
SELECT *
FROM emp
WHERE deptno = 10
   OR deptno = 20;


--�ǽ�3 (IN �ǽ�where3)
/*
    user ���̺��� userid�� brown, cony, sally�� �����͸�
    ������ ���� ��ȸ �Ͻÿ�.(IN ������ ���)
*/
desc users; --���̺� ������ ���(�̸�, ��?, ����)�� �˰������ ���
SELECT userid ���̵�, usernm �̸�, alias ����
FROM users
WHERE userid in('brown', 'cony', 'sally');

--COL LIKE 'S%'
--COL�� ���� �빮�� S�� �����ϴ� ��� ��
--COL LIKE 's____'  
--COL�� ���� �빮�� S�� �����ϰ� �̾ 4���� ���ڿ��� �����ϴ� ��

--emp ���̺��� �����̸��� S�� �����ϴ� ��� ���� ��ȸ
SELECT *
FROM emp
WHERE ename LIKE 'S%';

SELECT *
FROM emp
WHERE ename LIKE 'S____';

--���� ��ҹ��ڸ� ������
--WHERE ename LIKE 'SMITH';
--WHERE ename LIKE 'sMITH';

-- �ǽ�3 (LIKE, %, _ �ǽ� where4)
/*
    member ���̺��� ȸ���� ���� [��]���� ����� mem_id, mem_name
    �� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�.
*/

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE'��%';

--�ǽ�4 (LIKE, %,_ �ǽ� where5)
/*
    member ���̺��� ȸ���� �̸��� ����[��]�� ���� ��� �����
    mem_id, mem_name�� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�.
*/
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE'%��%'; -- mem_name�� ���ڿ� �ȿ� '��'�� ���Ե� ������
--WHERE mem_name LIKE'��%'; -- mem_name�� '��'�� �����ϴ� ������

--NULL ��
--col IS NULL
--EMP ���̺��� MGR ������ ���� ���(NULL) ��ȸ

SELECT *
FROM emp
WHERE mgr IS NULL;
--WHERE mgr != nill; -- null �񱳰� �����Ѵ�

--�ҼӺμ��� 10���� �ƴ� ������
SELECT *
FROM emp
WHERE deptno != '10';
--(=, !=)
--(is null, is not null)

--�ǽ�5 (IS NULL �ǽ� where6)
/*
    emp ���̺��� ��(comm)�� �ִ� ȸ���� ������ ������ ����
    ��ȸ�ǵ��� ������ �ۼ��Ͻÿ�.
*/
SELECT *
FROM emp
WHERE comm is not null;

--AND / OR
--������(mgr) ����� 7698�̰� �޿��� 1000 �̻��� ���
SELECT *
FROM emp
WHERE mgr  = 7698
  AND sal >= 1000;

--emp ���̺��� ������(mgr) ����� 7698 �̰ų�
--      �޿�(sal)�� 1000 �̻��� ���� ��ȸ
SELECT *
FROM emp
WHERE mgr  = 7698
  OR sal >= 1000;

--emp ���̺��� ������(mgr) ����� 7698�� �ƴϰ�, 7839�� �ƴ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr NOT IN (7698,7839); -- IN --> OR

--���� ������ AND/OR �����ڷ� ��ȯ
SELECT *
FROM emp
WHERE mgr != 7698
  AND mgr != 7839;
  
--IN, NOT IN  �������� NULL ó��
--emp ���̺��� ������(mgr) ����� 7698 �Ǵ� null�� �ƴ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839, NULL);
--IN �����ڿ��� ������� NULL�� ���� ��� �ǵ����� ���� ������ �Ѵ�.

SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839)
   AND mgr IS NOT NULL;

--�ǽ�7 ������(AND,OR �ǽ� where7)
/*
    emp���̺��� job�� SALESMAN�̰� �Ի����ڰ� 1981�� 6�� 1��
    ������ ������ ������ ������ ���� ��ȸ �ϼ���.
*/
SELECT *
FROM emp
WHERE job = 'SALESMAN'
  AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

--�ǽ�8 ������(AND,OR �ǽ� where8)
/*
    emp���̺��� �μ���ȣ�� 10���� �ƴϰ� �Ի����ڰ� 1981�� 6�� 1��
    ������ ������ ������ ������ ���� ��ȸ�ϼ���.
    (IN, NOT IN ������ ������)
*/
desc emp;
SELECT *
FROM emp
WHERE deptno != 10
  AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');
  
--�ǽ�9 ������(AND,OR �ǽ� where9)
/* 
    emp ���̺��� �μ���ȣ�� 10���� �ƴϰ� �Ի����ڰ� 1981�� 6�� 1��
    ������ ������ ������ ������ ���� ��ȸ�ϼ���.
    (NOT IN  ������ ���)
*/
SELECT *
FROM emp
WHERE deptno NOT IN 10
  AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');
 
 --�ǽ�10 ������(AND,OR �ǽ� where10)
 /*
    emp ���̺��� �μ���ȣ�� 10���� �ƴϰ� �Ի����ڰ� 1981�� 6�� 1��
    ������ ������ ������ ������ ���� ��ȸ�ϼ���.
    (�μ��� 10, 20, 30 �� �ִٰ� �����ϰ� IN �����ڸ� ���)
*/
SELECT *
FROM emp
WHERE deptno IN (20, 30)
  AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

 --�ǽ�11 ������(AND,OR �ǽ� where11)
 /*
    emp���̺��� job�� SALESMAN�̰ų� �Ի����ڰ� 1981�� 6�� 1��
    ������ ������ ������ ������ ���� ��ȸ�ϼ���.
*/
SELECT *
FROM emp
WHERE job = 'SALESMAN'
  OR hiredate >= TO_DATE('19810601', 'YYYYMMDD');
--�ǽ�12 ������(AND,OR �ǽ� where12)
/*
    emp ���̺��� job�� SALESMAN�̰ų� �����ȣ�� 78�� �����ϴ�
    ������ ������ ������ ���� ��ȸ �ϼ���.
*/
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno LIKE '78%';
 --�ǽ�13 ������(AND,OR �ǽ� where13)
 /*
    emp ���̺��� job�� SALESMAN�̰ų� �����ȣ�� 78�� �����ϴ�
    ������ ������ ������ ���� ��ȸ �ϼ���.
    (LIKE�� ������� ����)
*/
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno/100 = 78;
   