--����
--WHERE
--������
-- �� : =, !=, <>, >=, >, <=, <
-- BETWEEN start AND end
-- IN (set)
-- LIKE 'S%' (% : �ټ��� ���ڿ��� ��Ī, _ : ��Ȯ�� �ѱ��� ��Ī
-- NULL ( != NULL )
-- AND, OR, NOT

-- emp ���̺��� �Ի����ڰ� 1981�� 6�� 1�Ϻ��� 1986�� 12�� 31�� ���̿� �ִ�
-- ���� ������ȸ

-- BETWEEN AND ���
SELECT *
FROM emp
WHERE hiredate BETWEEN TO_DATE('1981/06/01', 'YYYY/MM/DD')
                  AND TO_DATE('1986/12/01', 'YYYY/MM/DD');
-- >=, <=
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD')
  AND hiredate <= TO_DATE('1986/12/01', 'YYYY/MM/DD');
  
-- emp ���̺��� ������(mgr)�� �ִ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr IS NOT NULL; -- (!= NULL�� �ȵ�)

--where12
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno LIKE '78%';
   
--where13
--empno�� ����4�ڸ����� ���
desc emp;
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno/100  >= 78 AND empno/100 < 79;

--where14
/*
    emp ���̺���  job�� SALESMAN�̰ų� �����ȣ�� 78�� �����ϸ鼭
    �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ������ ���� ��ȸ �ϼ���.
*/
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno LIKE '78%' AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');
   
--order by �÷��� | ��Ī | �÷��ε��� [ASC | DESC]
--order by ������ WHERE�� ������ ���
--WHERE ���� ���� ��� FROM�� ������ ���
-- emane �������� �������� ����

SELECT *
FROM emp
ORDER BY ename ASC;

--ASC : dafault
--ASC�� �Ⱥٿ��� �� ������ ������
SELECT *
FROM emp
ORDER BY ename; --ASC (�⺻ ��������)

--�̸�(ename)�� �������� ��������
SELECT *
FROM emp
ORDER BY ename DESC;

--job�� �������� ������������ ����, ���� job�� �������
--��� (empno)���� �ø����� ����
SELECT *
FROM emp
ORDER BY job DESC, empno ASC;

--��Ī���� �����ϱ�
--��� ��ȣ(empno). �����(ename), ����(sal * 12) as year_sal
--year_sal ��Ī���� �������� ����
SELECT empno, ename, sal, sal*12 as year_sal
FROM emp
ORDER BY year_sal;

--SELECT�� �÷� ���� �ε����� ����
SELECT empno, ename, sal, sal*12 as year_sal
FROM emp
ORDER BY 2; -- 2��° �÷� ������ ��������

--(�ǽ� oderby1)
/*
    - dept ���̺��� ��������� �μ��̸����� �������� ���ķ� ��ȸ�ǵ��� ������ �ۼ��ϼ���.
    - dept ���̺��� ��� ������ �μ���ġ�� �������� ���ķ� ��ȸ�ǵ��� ������ �ۼ��ϼ���.
*/
SELECT *
FROM dept
ORDER BY dname, loc desc;

--(�ǽ� orderby2)
/*
    emp ���̺��� ��(comm) ������ �ִ� ����鸸 ��ȸ�ϰ�,
    ��(comm)�� ���� �޴� ����� ���� ��ȸ�ǵ��� �ϰ�, �󿩰� �������
    ������� �������� �����ϼ���.
*/
SELECT *
FROM emp
WHERE comm IS NOT NULL
ORDER BY comm DESC, empno;

--(�ǽ� orderby3)
/*
    emp ���̺��� �����ڰ� �ִ� ����鸸 ��ȸ�ϰ�,
    ����(job)������ �������� �����ϰ�, ������ ���� ���
    ����� ū ����� ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���.
*/
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job ASC, empno DESC;

--(�ǽ� orderby4)
/*
    emp ���̺��� 10�� �μ�(deptno) Ȥ�� 30�� �μ��� ���ϴ� �����
    �޿�(sal)�� 1500�� �Ѵ� ����鸸 ��ȸ�ϰ� �̸����� �������� ���ĵǵ���
    ������ �ۼ��ϼ���.
*/
SELECT *
FROM emp
WHERE deptno IN (10,30)
  AND sal > 1500
ORDER BY ename DESC;

desc emp;
SELECT ROWNUM empno, ename
FROM emp
WHERE ROWNUM <= 2;
--WHERE ROWNUM <= 10;

--emp ���̺��� ���(empno), �̸�(ename)�� �޿� �������� �������� �����ϰ�
-- ���ĵ� ��������� ROWBUM
SELECT ROWNUM, empno , ename, sal
FROM emp 
ORDER BY sal;

SELECT ROWNUM, a.*
FROM
(SELECT empno , ename, sal
FROM emp 
ORDER BY sal) a ;

--�����÷� ROWNUM �ǽ� row 1
/*
    emp ���̺��� ROwNUM ���� 1_10�� ���� ��ȸ�ϴ� ������
    �ۼ��غ�����. (���ľ��� ����)
*/
SELECT ROWNUM, a.*
FROM
    (SELECT empno , ename, sal
    FROM emp
    ORDER BY sal) a
WHERE ROWNUM <=10;

--ROWNUM �ǽ� row_2
/*
    ROWNUM ���� 11~20�� ���� ��ȸ�ϴ� ������ �ۼ��� ������.
    HINT : alias, inline-view
(���� : ROWNUM�� ��Ī�� �ְ�, 
*/

SELECT b.*
FROM
    (SELECT ROWNUM rn, a.* --ROWNUM�� 1���Ͱ˻��� �����ؾ��ϴµ� ��Ī�� �־� ���̺� ���·� ������ �ָ� ����
    FROM
        (SELECT empno, ename,sal
        FROM emp
        ORDER BY sal) a 
    WHERE ROWNUM <= 14) b
WHERE rn >10;

---------- ������ �ؼ� ----------
SELECT *
FROM
    ( SELECT ROWNUM rn, B.*
    FROM
        (SELECT empno, ename,sal
        FROM emp
        ORDER BY sal) B)
WHERE rn BETWEEN 11 AND 14;
---------------------------------

--FUNCTION
--DUAL ���̺� ��ȸ
SELECT 'HELLO WORLD' as msg
FROM DUAL;

SELECT 'HELLO WORLD'
FROM emp;

-- ���ڿ� ��ҹ��� ���õ� �Լ�
-- LOWER, UPPER, INITCAP
SELECT LOWER('Hellon World'),
        UPPER('Hellon World'),
        INITCAP('Hellon World')
FROM emp
WHERE job = 'SALESMAN';

--FUNCTION�� WHERE�������� ��밡��
SELECT *
FROM emp
WHERE LOWER(ename) = 'smith';
--WHERE ename = UPPER('smith'); --���� ����� ����(������ �� ������� ����)

--������ SQL ĥ������
-- 1. �º��� �������� ���ƶ�
-- �º�(TABLE �� �÷�)�� �����ϰ� �Ǹ� INDEX�� ���������� ������� ����
-- Function Based Index -> FBI

--CONCAT : ���ڿ� ���� - �ΰ��� ���ڿ��� �����ϴ� �Լ�
--(���� �ΰ��� ������ ����)
--SUBSTR : ���ڿ��� �κ� ���ڿ�(java : String.substring)
--LENGTH : ���ڿ��� ����
--INSTR : ���ڿ��� Ư�� ���ڿ��� �����ϴ� ù��° �ε���
--LPAD : ���ڿ��� Ư�� ���ڿ��� ����
SELECT CONCAT(CONCAT('HELLO',', ') ,' WORLD')CONCAT,
        SUBSTR('HELLO, WORLD', 0 , 5) substr,
        SUBSTR('HELLO, WORLD', 1 , 5) substr1,
        LENGTH('HELLO, WORLD') length,
        --INSTR(���ڿ�, ã�� ���ڿ�, ���ڿ��� Ư�� ��ġ ���� ǥ��)
        INSTR('HELLO, WORLD', 'O', 6) instr1, --6������ O�� ã��
        --LPAD(���ڿ�, ��ü ���ڿ� ����, ���ڿ��� ��ü ���ڿ����̿� ��ġ�� ���Ұ�� �߰��� ����)
        --    (�߰��� ���ڸ� �������� ������ " "������ ��)
        LPAD('HELLO, WORLD', 15, '*') lpad,
        LPAD('HELLO, WORLD', 15) lpad,
        LPAD('HELLO, WORLD', 15, ' ') lpad,
        RPAD('HELLO, WORLD', 15, '*') lpad
FROM dual;