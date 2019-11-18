SELECT *
FROM USER_VIEWS;

SELECT *
FROM ALL_VIEWS
WHERE OWNER = 'PC14';

SELECT *
FROM PC14.V_EMP_DEPT;

--pc14 �������� ��ȸ������ ���� V_EMP_DEPT view�� hr �������� ��ȸ�ϱ�
--���ؼ��� ������.view�̸� �������� ����ؾ��Ѵ�.
--�Ź� �������� ����ϱ� �������Ƿ� �ó���� ���� �ٸ� ��Ī�� ����

CREATE SYNONYM V_EMP_DEPT FOR PC14.V_EMP_DEPT;

--PC14.V_EMP_DEPT --> V_EMP_DEPT
SELECT *
FROM V_EMP_DEPT;

--�üҴ� ����
DROP TABLE ���̺��;
DROP SYNONYM �ó�Ը�;
DROP SYNONYM V_EMP_DEPT;


--hr ���� ��й�ȣ : java
--hr ���� ��й�ȣ ���� : hr
ALTER USER hr IDENTIFIED BY hr;
--ALTER USER pc14 IDENTIFIED BY java; --���� ������ �ƴ϶� ������.

--dictionary
--���ξ�  : USER : ����� ���� ��ü
--         ALL  : ����� ��밡�� �� ��ü
--         DBA  : ������ ���� ��ü ��ü(�Ϲ� ����ڴ� ��� �Ұ�)
--         V$   : �ý��۰� ���õ� view(�Ϲ� ����ڴ� ��� �Ұ�)
SELECT *
FROM USER_TABLES;

SELECT *
FROM ALL_TABLES;

SELECT *
FROM DBA_TABLES
WHERE OWNER IN('PC14', 'HR');

--����Ŭ���� ������ SQL�̶�?
--���ڰ� �ϳ��� Ʋ���� �ȵ�
--���� SQL���� ��������� ����� ���� ���� DBMS������
--���� �ٸ� SQL�� �νĵȴ�.
SELECT /*bind_test */ * FROM emp;
Select /*bind_test */ * FROM emp;
Select /*bind_test */ * FROM emp;

Select /*bind_test */ * FROM emp WHERE empno = 7369;
Select /*bind_test */ * FROM emp WHERE empno = 7499;
Select /*bind_test */ * FROM emp WHERE empno = 7521;

Select /*bind_test */ * FROM emp WHERE empno =:empno;

SELECT * 
FROM V$SQL
WHERE SQL_TEXT LIKE '%bind_test%';