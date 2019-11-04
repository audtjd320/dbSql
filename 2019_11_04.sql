--���� where11
/*
    job�� SALESMAN�̰ų� �Ի����ڰ� 1981�� 6�� 1�� ������ �������� ��ȸ
*/
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');
   
--ROWNUM
SELECT ROWNUM, emp.*
FROM emp;

SELECT ROWNUM, e.*
FROM emp e;

--ROWNUM ���� ����
--ORDER BY���� SELECT �� ���Ŀ� ����
--ROWNUM �����÷��� ����ǰ��� ���ĵǱ� ������
--�츮�� ���ϴ´�� ù��° �����ͺ��� �������� ��ȣ�� �ο� ���� �ʴ´�.
SELECT ROWNUM, e.*
FROM emp e
ORDER BY ename;

--ORDER BY ���� ������ �ζ��� �並 �Լ�
SELECT ROWNUM, a.*
FROM
    (SELECT e.*
    FROM emp e
    ORDER BY ename) a;

--ROWNUM : 1������ �о�� �ȴ�.
--WHERE���� ROWNUM���� �߰��� �д°� �Ұ���
--�ȵǴ� ���̽�
-- WHERE ROWNUM = 2
-- WHERE ROWNUM >= 2

--������ ���̽�
-- WHERE ROWNUM = 1
-- WHERE ROWNUM <= 10

SELECT ROWNUM, a.*
FROM
    (SELECT e.*
    FROM emp e
    ORDER BY ename) a;

--����¡ ó���� ���� �ļ� ROWNUM�� ��Ī�� �ο�, �ش� SQL��  INLINE VIEW��
--���ΰ� ��Ī�� ���� ����¡ ó��
SELECT *
FROM
    (SELECT ROWNUM, a.*
    FROM
        (SELECT e.*
        FROM emp e
        ORDER BY ename)  a)
WHERE rn BETWEEN 10 AND 14;

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
        RPAD('HELLO, WORLD', 15, '*') rpad,
        --REPLACE(�������ڿ�, ���� ���ڿ����� �����ϰ��� �ϴ� ��� ���ڿ�, ���湮�ڿ�)
        REPLACE(REPLACE('HELLO, WORLD', 'HELLO', 'hello'), 'WORLD', 'world') replace,
        TRIM('  HELLO, WORLD  ') trim,
        --���ڿ� �յڷ� Ư�� ���ڿ� ����
        TRIM('H' FROM 'HELLO, WORLD') trim2
FROM dual;

 
--ROUND(������, �ݿø� ��� �ڸ���)
SELECT ROUND(105.54, 1) r1,--�Ҽ��� ��° �ڸ����� �ݿø�
        ROUND(105.55, 1) r2,--�Ҽ��� ��° �ڸ����� �ݿø�
        ROUND(105.55, 0) r3, --�Ҽ��� ù° �ڸ����� �ݿø�
        ROUND(105.55, -1) r4 --���� ù° �ڸ����� �ݿø�
FROM dual;

SELECT empno, ename,
        sal, sal/1000, /*ROUND(sal/1000) quotient,*/ MOD(sal,1000) reminder 
FROM emp;

--TRUNC
SELECT 
TRUNC(105.54, 1) T1,--�Ҽ��� ��° �ڸ����� ����
TRUNC(105.55, 1) T2,--�Ҽ��� ��° �ڸ����� ����
TRUNC(105.55, 0) T3, --�Ҽ��� ù° �ڸ����� ����
TRUNC(105.55, -1) T4 --���� ù° �ڸ����� ����
FROM dual;


-- SYSDATE : ����Ŭ�� ��ġ�� ������ ���� ��¥ + �ð������� ����
-- ������ ���ڰ� ���� �Լ�

--TO_CHAR : DATE Ÿ���� ���ڿ��� ��ȯ
-- ��¥�� ���ڿ��� ��ȯ�ÿ� ������ ����
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS'),
       TO_CHAR(SYSDATE + (1/24/60) * 30, 'YYYY/MM/DD HH24:MI:SS')
FROM dual;

--date �ǽ� fn1
/*
    1. 2019�� 12�� 31���� date ������ ǥ��
    2. 2019�� 12�� 31���� date ������ ǥ���ϰ� 5�� ���� ��¥
    3. ���� ��¥
    4. ���� ��¥���� 3���� ��
*/
SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD') lastday,
       TO_DATE('2019/12/31', 'YYYY/MM/DD') -5 lastday_before5,
       TO_CHAR(SYSDATE, 'YYYY/MM/DD') now,
       TO_CHAR(SYSDATE -3, 'YYYY/MM/DD') now_before3
FROM dual;

--INLINE VIEW �̿� ���
SELECT LASTDAY, LASTDAY-5 AS LASTDAT_BEFORE5,
       NOW, NOW-3 NOW_BEFORE3
FROM
    (SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD') lastday,
           SYSDATE now
    FROM dual);
    
--date format
--�⵵ : YYYY, YY, RRRR, RR : ���ڸ��϶��� 4�ڸ��϶��� �ٸ�
-- RR : 50���� Ŭ��� ���ڸ��� 19, 50���� ������� ���ڸ��� 20
--YYYY, RRRR�� ����
-- �������̸� ��������� ǥ�����ٰ�
-- D : ������ ���ڷ� ǥ�� ( �Ͽ����� 1, �������� 2, ȭ������ 3 .... ������� 7)
SELECT TO_CHAR(TO_DATE('35/03/01','RR/MM/DD'), 'YYYY/MM/DD') r1,
       --50���� ũ�� 1900�⵵ 50���� ������ 2000�⵵
       TO_CHAR(TO_DATE('55/03/01','RR/MM/DD'), 'YYYY/MM/DD') r2,
       TO_CHAR(TO_DATE('35/03/01','yy/MM/DD'), 'YYYY/MM/DD') y1,
       TO_CHAR(SYSDATE, 'D') d, --������ ������ 2
       TO_CHAR(SYSDATE, 'IW') iw, -- ���� ǥ��
       TO_CHAR(TO_DATE('20191231', 'YYYYMMDD'), 'IW') this_year
FROM DUAL; 

--date �ǽ� fn2
/*
    ���� ��¥�� ������ ���� �������� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�.
    1. ��-��-��
    2. ��-��-�� �ð�(24)-��-��
    3. ��-��-��
*/

SELECT TO_CHAR(TO_DATE('20191024', 'YYYYMMDD'), 'YYYY-MM-DD') DT_DASH,
       TO_CHAR(TO_DATE('20191024', 'YYYYMMDD'), 'YYYY-MM-DD HH24:MI:SS') DT_DASH_WIDTH_TIME,
       TO_CHAR(TO_DATE('2019.10.24', 'YYYY.MM.DD'), 'DD-MM-YYYY') DT_DD_MM_YYYY
FROM DUAL;

--��¥�� �ݿø�(ROUND) ,����(TRUNC)
--ROUND (DATE, '����') YYYY, MM, DD
desc emp;
SELECT ename, TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS')as hiredate,
       TO_CHAR(ROUND(hiredate, 'YYYY'), 'YYYY/MM/DD HH24:MI:SS') as round_yyyy,
       TO_CHAR(ROUND(hiredate, 'DD'), 'YYYY/MM/DD HH24:MI:SS') as round_dd,
       TO_CHAR(ROUND(hiredate, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as round_mm,
       TO_CHAR(ROUND(hiredate-2, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as round_mm
FROM emp
WHERE ename = 'SMITH';

SELECT ename, 
TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS')as hiredate,
TO_CHAR(TRUNC(hiredate, 'YYYY'), 'YYYY/MM/DD HH24:MI:SS') as trunc_yyyy,
TO_CHAR(TRUNC(hiredate, 'DD'), 'YYYY/MM/DD HH24:MI:SS') as trunc_dd,
TO_CHAR(TRUNC(hiredate, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as trunc_mm,
TO_CHAR(TRUNC(hiredate-2, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as trunc_mm
FROM emp
WHERE ename = 'SMITH';

SELECT SYSDATE + 30 --28, 29, 31
FROM DUAL;

-- ��¥ ���� �Լ�(�߿�)
-- MONTH_BETWEEN(DATE, DATE) : �� ��¥ ������ ���� ��
-- 1980/12/17~ 2019/10/04 --> 2019/11/17
SELECT ename, TO_CHAR(hiredate, 'YYYY-MM-DD HH24:MI:SS') hiredate,
       MONTHS_BETWEEN(SYSDATE, hiredate) month_between,
       MONTHS_BETWEEN(TO_DATE('20191117', 'YYYYMMDD'), hiredate) month_between
FROM emp
WHERE ename='SMITH';

--ADD_MONTH(DATE, ������) : DATE�� �������� ���� ��¥
--�������� ����� ��� �̷�, ������ ��� ����
SELECT ename, TO_CHAR(hiredate, 'YYYY-MM-DD HH24:MI:SS') hiredate,
       ADD_MONTHS(hiredate, 467) add_months,
       ADD_MONTHS(hiredate, -467) add_months
FROM emp
WHERE ename='SMITH';

--NEXT_DAY(DATE, ����) : DATE ���� ù��° ������ ��¥
SELECT SYSDATE,
       NEXT_DAY(SYSDATE, 7) first_sat, --���ó�¥���� ù ����� ����
       NEXT_DAY(SYSDATE, '�����') first_sat     
FROM dual;

--LAST_DAY(DATE)�ش� ��¥�� ���� ���� ������ ����
SELECT SYSDATE, LAST_DAY(SYSDATE) LAST_DAY,
       LAST_DAY(ADD_MONTHS(SYSDATE,1)) LAST_DAY_12
FROM dual;

--DATE + ���� =DATE (DATE���� ������ŭ ������ DATE)
--D1 + ���� = D2
--�纯���� D2 ����
--D1 + ���� - D2 = D2-D2
--D1 + ���� - D2 = 0
--D1 + ���� = D2
--�纯�� D1 ����
--D1 + ���� -D1 = D2 - D1
--���� = D2 - D1
--��¥���� ��¥�� ���� ���ڰ� ���´�
SELECT TO_DATE('20191104', 'YYYYMMDD') -TO_DATE('20191101', 'YYYYMMDD') D1,
       TO_DATE('20191201', 'YYYYMMDD') -TO_DATE('20191101', 'YYYYMMDD') D2,
       -- 201908 : 2019�� 8���� �ϼ� : 31
       ADD_MONTHS(TO_DATE('201908', 'YYYYMM'), 1) - TO_DATE('201908', 'YYYYMM') D3
FROM dual;
